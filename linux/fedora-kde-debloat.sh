#!/usr/bin/env bash
# Purpose: Removes preinstalled applications not needed on this system.
# Scope: One-shot post-install script for the Fedora KDE spin.
# Dependencies: dnf; sudo privileges. Interactive — dnf prompts before removal.
# Standard: dnf(8).

# --skip-unavailable: dnf5 (Fedora 41+) otherwise aborts the whole
# transaction if any listed package is not installed, which breaks reruns
# and machines that never had one of these preinstalled.
sudo dnf remove --skip-unavailable abrt akregator digikam dragon elisa-player filelight gnome-disk-utility k3b kaddressbook kcharselect kdebugsettings kde-connect kfind khelpcenter kjournald kleopatra kmahjongg kmail kmines kmouth korganizer kpat krdc krfb krusader ktorrent neochat plasma-welcome plasma-discover qrca skanpage
