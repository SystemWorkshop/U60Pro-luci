# 🧩 Installing LuCI on ZTE U60Pro ZWrt (based on OpenWrt)

This guide is designed for **heavily modified vendor firmware** like ZTE devices where:

- Root filesystem is **read-only**
- System uses **custom web UI (zteweb)**
- Standard OpenWrt init system is partially broken

The goal is simple:

👉 Get **LuCI running reliably without breaking the stock system**

------

# 🧠 Strategy (Read This First)

We follow a strict order to avoid breaking the system:

1. Mount overlay correctly (**critical step**)
2. Fix `opkg`
3. Install LuCI with full dependencies
4. Replace vendor-broken components
5. Start services manually (no init.d)
6. Launch LuCI

------

# 📁 Prepare Files

Place the following scripts into:

```bash
/data/tools
```

Required files:

- `overlay.sh`
- `zteweb.sh`
- `luci.sh`

Transfer them using:

- `scp`
- `adb`
- or any file transfer method

------

# ⚠️ Boot Auto-Start Setup (Optional but Recommended)

Append the following **before `exit 0`** in `/etc/rc.local`:

```bash
sh /data/tools/overlay.sh &
sh /data/tools/overlay.sh &

sh /data/tools/zteweb.sh &
sh /data/tools/luci.sh &
```

Running overlay twice is intentional to avoid inconsistent mount issues.

------

# 🚀 Step 1: Mount Overlay (DO THIS FIRST)

Run twice:

```bash
sh /data/tools/overlay.sh
```

Verify:

```bash
mount | grep overlay
```

You must see overlay mounted on:

```text
/usr/lib
/usr/share
/www
```

If these are not mounted, **STOP here — nothing will work**

------

# ⚠️ Critical Warning

Do NOT overlay the entire `/usr`

👉 This will break the stock ZTE web interface (`zteweb`)

------

# 🚀 Step 2: Fix opkg

Clean cache:

```bash
rm -rf /tmp/opkg-lists
mkdir -p /tmp/opkg-lists
```

Update:

```bash
opkg update
```

------

# 🚀 Step 3: Install LuCI (Full Install)

Always force reinstall to remove vendor leftovers:

```bash
opkg install luci luci-base luci-mod-admin-full luci-theme-bootstrap --force-reinstall
```

------

# 🚀 Step 4: Install uhttpd (Required)

Vendor version is incompatible with LuCI:

```bash
opkg install uhttpd uhttpd-mod-ucode uhttpd-mod-lua --force-reinstall
```

------

# 🚀 Step 5: Install Runtime Dependencies

```bash
opkg install rpcd luci-lib-base luci-lib-nixio --force-reinstall
```

Optional but recommended:

```bash
opkg install luci-app-firewall --force-reinstall
```

------

# 🚀 Step 6: Clear LuCI Cache

```bash
rm -f /tmp/luci-indexcache
```

------

# 🚀 Step 7: Launch LuCI

Run:

```bash
sh /data/tools/luci.sh
```

------

# 🌐 Access LuCI

Open:

```text
http://DEVICE_IP/cgi-bin/luci
```

------

# 🧪 Expected Result

You should see:

- LuCI login page
- No refresh loop
- No template errors

------

# 🔍 If It Doesn't Work

Check these paths:

```bash
ls /usr/lib/lua/luci
ls /usr/share/ucode/luci
ls /usr/lib/lua/luci/view/themes/bootstrap
```

If missing → reinstall with `--force-reinstall`

------

# ⚠️ Known Limitations

Because this is a vendor-modified system:

- WiFi configuration may NOT work (Qualcomm proprietary drivers)
- Multiple SSIDs may be unsupported
- Some LuCI modules may be broken
- ZTE web UI (port 8080) may behave inconsistently