{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  services.glance = {
    enable = true;
    settings = {
      server = {
        port = 8765;
      };
      pages = [
        {
          name = "Home";
          columns = [
            {
              size = "small";
              widgets = [
                {
                  type = "calendar";
                  first-day-of-week = "monday";
                }
                {
                  type = "rss";
                  limit = 10;
                  collapse-after = 3;
                  cache = "12h";
                  feeds = [
                    {
                      url = "https://selfh.st/rss/";
                      title = "selfh.st";
                      limit = 4;
                    }
                    {url = "https://ciechanow.ski/atom.xml";}
                    {
                      url = "https://www.joshwcomeau.com/rss.xml";
                      title = "Josh Comeau";
                    }
                    {url = "https://samwho.dev/rss.xml";}
                    {
                      url = "https://ishadeed.com/feed.xml";
                      title = "Ahmad Shadeed";
                    }
                  ];
                }
                {
                  type = "twitch-channels";
                  channels = ["theprimeagen" "j_blow" "piratesoftware" "cohhcarnage" "christitustech" "EJ_SA"];
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "search";
                  autofocus = true;
                }
                {
                  type = "monitor";
                  cache = "1m";
                  title = "Services";
                  sites = [
                    {
                      title = "Vaultwarden";
                      url = "https://vault.justinoh.io";
                      icon = "si:vaultwarden";
                    }
                    {
                      title = "Immich";
                      url = "https://photos.justinoh.io";
                      icon = "si:immich";
                    }
                    {
                      title = "Paperless";
                      url = "https://paperless.justinoh.io";
                      icon = "si:paperless-ngx";
                    }
                    {
                      title = "Nextcloud";
                      url = "https://files.justinoh.io";
                      icon = "si:nextcloud";
                    }
                  ];
                }
                {
                  type = "bookmarks";
                  groups = [
                    {
                      title = "General";
                      links = [
                        {
                          title = "Gmail";
                          url = "https://mail.google.com/mail/u/0/";
                        }
                        {
                          title = "Amazon";
                          url = "https://www.amazon.com/";
                        }
                        {
                          title = "Github";
                          url = "https://github.com/";
                        }
                      ];
                    }
                    {
                      title = "Entertainment";
                      links = [
                        {
                          title = "YouTube";
                          url = "https://www.youtube.com/";
                        }
                        {
                          title = "Prime Video";
                          url = "https://www.primevideo.com/";
                        }
                        {
                          title = "Disney+";
                          url = "https://www.disneyplus.com/";
                        }
                      ];
                    }
                    {
                      title = "Social";
                      links = [
                        {
                          title = "Reddit";
                          url = "https://www.reddit.com/";
                        }
                        {
                          title = "Twitter";
                          url = "https://twitter.com/";
                        }
                        {
                          title = "Instagram";
                          url = "https://www.instagram.com/";
                        }
                      ];
                    }
                  ];
                }
              ];
            }
            {
              size = "small";
              widgets = [
                {
                  type = "weather";
                  location = "London, United Kingdom";
                  units = "metric";
                  hour-format = "12h";
                }
                {
                  type = "markets";
                  markets = [
                    {
                      symbol = "SPY";
                      name = "S&P 500";
                    }
                    {
                      symbol = "BTC-USD";
                      name = "Bitcoin";
                    }
                    {
                      symbol = "NVDA";
                      name = "NVIDIA";
                    }
                    {
                      symbol = "AAPL";
                      name = "Apple";
                    }
                    {
                      symbol = "MSFT";
                      name = "Microsoft";
                    }
                  ];
                }
                {
                  type = "releases";
                  cache = "1d";
                  repositories = ["glanceapp/glance" "go-gitea/gitea" "immich-app/immich" "syncthing/syncthing"];
                }
              ];
            }
          ];
        }
      ];
    };
    openFirewall = true;
  };
}
