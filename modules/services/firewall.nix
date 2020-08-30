{ pkgs, ...}:
{
  networking = {
    firewall = {
      enable = true;
      allowPing = true;
      extraCommands = ''
        # Make UPnP work
        ${pkgs.ipset}/bin/ipset create -exist upnp hash:ip,port timeout 3
        iptables -A OUTPUT -d 239.255.255.250/32 -p udp -m udp --dport 1900 -j SET --add-set upnp src,src --exist
        iptables -A INPUT -p udp -m set --match-set upnp dst,dst -j ACCEPT
      '';
    };
  };
}
