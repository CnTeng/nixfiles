{
  config,
  lib,
  pkgs,
  ...
}:
let
  maildirBasePath = ".local/share/maildir";
in
{
  config = lib.mkIf (lib.any (x: x.enable) (lib.attrValues config.accounts')) {
    hm' = {
      accounts.email.maildirBasePath = maildirBasePath;

      programs.aerc = {
        enable = true;
        extraBinds = {
          global = {
            H = ":prev-tab<Enter>";
            L = ":next-tab<Enter>";
            gT = ":prev-tab<Enter>";
            gt = ":next-tab<Enter>";
            "<C-\\>" = ":term<Enter>";
            "?" = ":help keys<Enter>";
            "<C-q>" = ":prompt 'Quit?' quit<Enter>";
          };

          messages = {
            q = ":prompt 'Quit?' quit<Enter>";

            j = ":next<Enter>";
            "<Down>" = ":next<Enter>";
            "<C-d>" = ":next 50%<Enter>";
            "<C-f>" = ":next 100%<Enter>";
            "<PgDn>" = ":next 100%<Enter>";

            k = ":prev<Enter>";
            "<Up>" = ":prev<Enter>";
            "<C-u>" = ":prev 50%<Enter>";
            "<C-b>" = ":prev 100%<Enter>";
            "<PgUp>" = ":prev 100%<Enter>";
            gg = ":select 0<Enter>";
            G = ":select -1<Enter>";

            "<C-n>" = ":next-folder<Enter>";
            "<C-p>" = ":prev-folder<Enter>";
            "<C-h>" = ":collapse-folder<Enter>";
            "<C-l>" = ":expand-folder<Enter>";

            v = ":mark -t<Enter>";
            V = ":mark -v<Enter>";

            "<Space>t" = ":toggle-threads<Enter>";
            zc = ":fold<Enter>";
            zo = ":unfold<Enter>";
            za = ":fold -t<Enter>";
            zM = ":fold -a<Enter>";
            zR = ":unfold -a<Enter>";
            "<Tab>" = ":fold -t<Enter>";

            zz = ":align center<Enter>";
            zt = ":align top<Enter>";
            zb = ":align bottom<Enter>";

            "<Enter>" = ":view<Enter>";
            o = ":view<Enter>";

            d = ":choose -o y 'Really delete this message?' delete-message<Enter>";
            a = ":read<Enter>:archive flat<Enter>";
            A = ":unmark -a<Enter>:mark -T<Enter>:read<Enter>:archive flat<Enter>";

            C = ":compose<Enter>";
            m = ":compose<Enter>";

            b = ":bounce<Space>";

            rr = ":reply -a<Enter>";
            rq = ":reply -aq<Enter>";
            Rr = ":reply<Enter>";
            Rq = ":reply -q<Enter>";

            c = ":cf<Space>";
            "$" = ":term<Space>";
            "!" = ":term<Space>";
            "|" = ":pipe<Space>";

            "/" = ":search<Space>";
            "\\" = ":filter<Space>";
            "n" = ":next-result<Enter>";
            "N" = ":prev-result<Enter>";
            "<Esc>" = ":unmark -a<Enter>:clear<Enter>";
            "<C-\[>" = ":unmark -a<Enter>:clear<Enter>";
          };

          "messages:folder=Drafts" = {
            "<enter>" = ":recall<enter>";
          };

          view = {
            "/" = ":toggle-key-passthrough<Enter>/";
            q = ":close<Enter>";
            o = ":open<Enter>";
            "<C-s>" = ":save<Enter>";
            "|" = ":pipe<Epace>";
            d = ":prompt 'Really delete this message?' 'delete-message'<Enter>";
            a = ":read<Enter>:archive flat<Enter>";

            "<C-y>" = ":copy-link <Space>";
            "<C-l>" = ":open-link <Space>";

            f = ":forward<Enter>";
            rr = ":reply -a<Enter>";
            rq = ":reply -aq<Enter>";
            Rr = ":reply<Enter>";
            Rq = ":reply -q<Enter>";

            H = ":toggle-headers<Enter>";
            "<C-k>" = ":prev-part<Enter>";
            "<C-Up>" = ":prev-part<Enter>";
            "<C-j>" = ":next-part<Enter>";
            "<C-Down>" = ":next-part<Enter>";
            J = ":next<Enter>";
            "<C-Right>" = ":next<Enter>";
            K = ":prev<Enter>";
            "<C-Left>" = ":prev<Enter>";
          };

          "view::passthrough" = {
            "$noinherit" = "true";
            "$ex" = "<C-x>";

            "<Esc>" = ":toggle-key-passthrough<Enter>";
            "<C-[>" = ":toggle-key-passthrough<Enter>";
          };

          compose = {
            "$noinherit" = "true";
            "$ex" = "<C-x>";
            "$complete" = "<C-o>";

            "<C-k>" = ":prev-field<Enter>";
            "<C-Up>" = ":prev-field<Enter>";
            "<C-j>" = ":next-field<Enter>";
            "<C-Down>" = ":next-field<Enter>";

            "<C-h>" = ":switch-account -p<Enter>";
            "<C-Left>" = ":switch-account -p<Enter>";
            "<C-l>" = ":switch-account -n<Enter>";
            "<C-Right>" = ":switch-account -n<Enter>";

            "<C-p>" = ":prev-tab<Enter>";
            "<C-PgUp>" = ":prev-tab<Enter>";
            "<C-n>" = ":next-tab<Enter>";
            "<C-PgDn>" = ":next-tab<Enter>";
          };

          "compose::editor" = {
            "$noinherit" = "true";
            "$ex" = "<C-x>";

            "<C-k>" = ":prev-field<Enter>";
            "<C-Up>" = ":prev-field<Enter>";
            "<C-j>" = ":next-field<Enter>";
            "<C-Down>" = ":next-field<Enter>";

            "<C-p>" = ":prev-tab<Enter>";
            "<C-PgUp>" = ":prev-tab<Enter>";
            "<C-n>" = ":next-tab<Enter>";
            "<C-PgDn>" = ":next-tab<Enter>";
          };

          "compose::review" = {
            "y" = ":send<Enter>";
            "Y" = ":send -a flat<Enter>";
            "q" = ":abort<Enter>";
            "v" = ":preview<Enter>";
            "p" = ":postpone<Enter>";
            "e" = ":edit<Enter>";
            "a" = ":attach -m<space>";
            "d" = ":detach<space>";
          };

          terminal = {
            "$noinherit" = "true";
            "$ex" = "<C-x>";

            H = ":prev-tab<Enter>";
            L = ":next-tab<Enter>";
            "<C-\\>" = ":close<Enter>";
          };
        };
        extraConfig = {
          general = {
            unsafe-accounts-conf = true;
            enable-osc8 = true;
            default-menu-cmd = "fzf --multi";
          };

          ui = {
            column-flags = "{{.Flags | join \" \"}}";
            tab-title-account = "{{.Account}} {{if .Unread}}({{.Unread}}){{end}}";
            sort = "-r date";
            fuzzy-complete = true;

            icon-encrypted = "";
            icon-signed = "";
            icon-signed-encrypted = "";
            icon-unknown = "";
            icon-invalid = "";
            icon-attachment = "";
            icon-new = "";
            icon-old = "";
            icon-replied = "";
            icon-forwarded = "";
            icon-flagged = "";
            icon-marked = "";
            icon-draft = "";
            icon-deleted = "";

            threading-enabled = true;
            show-thread-context = true;
          };

          filters = {
            "text/plain" = "colorize";
            "text/calendar" = "calendar";
            "text/html" = "html";
            "message/delivery-status" = "colorize";
            "message/rfc822" = "colorize";
            "image/*" = "${lib.getExe pkgs.catimg} -";
          };
        };
      };

      programs.mbsync.enable = true;
      services.imapnotify = {
        enable = true;
        path = [ pkgs.coreutils ];
      };
    };

    preservation'.user.directories = [ maildirBasePath ];
  };
}
