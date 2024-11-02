#!/bin/sh -eux

# change quarterly to latest for rolling
mkdir -p /usr/local/etc/pkg/repos
cat >> /usr/local/etc/pkg/repos/FreeBSD.conf << 'EOT'
FreeBSD: {
  url: "http://mirrors.ustc.edu.cn/freebsd-pkg/${ABI}/quarterly",
  mirror_type: "none",
}
EOT

pkg install -y sudo bash vim xorg xfce xrdp

pw usermod vagrant -s /usr/local/bin/bash
sysrc dbus_enable="YES"
sysrc xrdp_enable="YES"
sysrc xrdp_sesman_enable="YES"
cat >> /usr/local/etc/X11/xorg.conf.d/driver.conf << 'EOT'
Section "Device"
    Identifier "Card0"
    Driver     "scfb"
EndSection
EOT

cat >> $HOME/.profile << 'EOT'
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
EOT

sed -i '' 's/::1			localhost localhost.my.domain/::1			freebsd localhost localhost.my.domain/g' /etc/hosts
sed -i '' 's/127.0.0.1		localhost localhost.my.domain/127.0.0.1		freebsd localhost localhost.my.domain/g' /etc/hosts

sed -i '' 's/# exec startxfce4/exec startxfce4/g' /usr/local/etc/xrdp/startwm.sh
sed -i '' 's/exec xterm/# exec xterm/g' /usr/local/etc/xrdp/startwm.sh
sed -i '' 's/#EnableFuseMount=false/EnableFuseMount=false/g' /usr/local/etc/xrdp/sesman.ini

mkdir -p $HOME/.config/xfce4/xfconf/xfce-perchannel-xml
cat >> $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml << 'EOT'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-panel" version="1.0">
  <property name="configver" type="int" value="2"/>
  <property name="panels" type="array">
    <value type="int" value="1"/>
    <property name="dark-mode" type="bool" value="true"/>
    <property name="panel-1" type="empty">
      <property name="position" type="string" value="p=8;x=640;y=786"/>
      <property name="length" type="uint" value="100"/>
      <property name="position-locked" type="bool" value="true"/>
      <property name="icon-size" type="uint" value="32"/>
      <property name="size" type="uint" value="48"/>
      <property name="plugin-ids" type="array">
        <value type="int" value="1"/>
        <value type="int" value="2"/>
        <value type="int" value="3"/>
        <value type="int" value="4"/>
        <value type="int" value="5"/>
        <value type="int" value="8"/>
        <value type="int" value="11"/>
        <value type="int" value="12"/>
      </property>
    </property>
  </property>
  <property name="plugins" type="empty">
    <property name="plugin-2" type="string" value="tasklist">
      <property name="grouping" type="uint" value="1"/>
      <property name="show-labels" type="bool" value="false"/>
      <property name="show-handle" type="bool" value="true"/>
    </property>
    <property name="plugin-3" type="string" value="separator">
      <property name="expand" type="bool" value="true"/>
      <property name="style" type="uint" value="0"/>
    </property>
    <property name="plugin-4" type="string" value="pager">
      <property name="rows" type="uint" value="2"/>
    </property>
    <property name="plugin-5" type="string" value="separator">
      <property name="style" type="uint" value="0"/>
    </property>
    <property name="plugin-8" type="string" value="pulseaudio">
      <property name="enable-keyboard-shortcuts" type="bool" value="true"/>
      <property name="show-notifications" type="bool" value="true"/>
    </property>
    <property name="plugin-11" type="string" value="separator">
      <property name="style" type="uint" value="0"/>
    </property>
    <property name="plugin-12" type="string" value="clock">
      <property name="digital-layout" type="uint" value="3"/>
      <property name="digital-time-font" type="string" value="Sans 16"/>
    </property>
    <property name="plugin-1" type="string" value="applicationsmenu"/>
  </property>
</channel>
EOT
mkdir -p $HOME/.config/xfce4/terminal
cat >> $HOME/.config/xfce4/terminal/terminalrc << 'EOT'
[Configuration]
MiscAlwaysShowTabs=FALSE
MiscBell=FALSE
MiscBellUrgent=FALSE
MiscBordersDefault=TRUE
MiscCursorBlinks=FALSE
MiscCursorShape=TERMINAL_CURSOR_SHAPE_BLOCK
MiscDefaultGeometry=80x24
MiscInheritGeometry=FALSE
MiscMenubarDefault=TRUE
MiscMouseAutohide=FALSE
MiscMouseWheelZoom=TRUE
MiscToolbarDefault=FALSE
MiscConfirmClose=TRUE
MiscCycleTabs=TRUE
MiscTabCloseButtons=TRUE
MiscTabCloseMiddleClick=TRUE
MiscTabPosition=GTK_POS_TOP
MiscHighlightUrls=TRUE
MiscMiddleClickOpensUri=FALSE
MiscCopyOnSelect=FALSE
MiscShowRelaunchDialog=TRUE
MiscRewrapOnResize=TRUE
MiscUseShiftArrowsToScroll=FALSE
MiscSlimTabs=FALSE
MiscNewTabAdjacent=FALSE
MiscSearchDialogOpacity=100
MiscShowUnsafePasteDialog=TRUE
MiscRightClickAction=TERMINAL_RIGHT_CLICK_ACTION_CONTEXT_MENU
ScrollingBar=TERMINAL_SCROLLBAR_NONE
EOT


chown -R vagrant: $HOME/.cache $HOME/.config $HOME/.profile

pkg autoremove --yes && pkg clean --yes --all
rm -rf /var/db/pkg/repos/FreeBSD