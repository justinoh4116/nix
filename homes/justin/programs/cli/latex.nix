{
  lib,
  pkgs,
  self,
  config,
  ...
}: let
  texlive =
    pkgs.lib.overrideDerivation (pkgs.texlive.combine {
      inherit
        (pkgs.texlive)
        scheme-basic
        dinbrief
        german
        mnsymbol
        crimson
        xkeyval
        mweights
        ucs
        totpages
        booktabs
        lm
        ms
        setspace
        tabu
        xcolor
        soul
        varwidth
        enumitem
        collection-fontsrecommended
        ulem
        titlesec
        hyperref
        memoir
        hyphen-german
        hyphen-english
        multirow
        csquotes
        etoolbox
        subfigure
        subfig
        caption
        spreadtab
        fp
        xstring
        siunitx
        l3kernel
        l3packages
        xint
        xifthen
        isodate
        substr
        dvisvgm
        fontspec
        fontaxes
        xetex
        ;
      minionpro.pkgs = [config.nur.repos.clefru.minionpro];
    }) (oldAttrs: {
      # postBuild =
      #   ''
      #     # Save the udpmap.cfg because texlive.combine removes it.
      #     cat $out/share/texmf/web2c/updmap.cfg > $out/share/texmf/web2c/updmap.cfg.1
      #   ''
      #   + oldAttrs.postBuild
      #   + ''
      #     # Move updmap.cfg into its original place and rerun mktexlsr, so that kpsewhich finds it
      #     rm $out/share/texmf/web2c/updmap.cfg || true
      #     cat $out/share/texmf/web2c/updmap.cfg.1 > $out/share/texmf/web2c/updmap.cfg
      #     rm $out/share/texmf/web2c/updmap.cfg.1
      #     perl `type -P mktexlsr.pl` $out/share/texmf
      #
      #     yes | perl `type -P updmap.pl` --sys --syncwithtrees --force || true
      #     perl `type -P updmap.pl` --sys --enable Map=MinionPro.map --enable Map=MyriadPro.map
      #
      #     # Add minionpro/myriad
      #     #echo "Map MinionPro.map" >> $out/share/texmf/web2c/updmap.cfg
      #     #echo "Map MyriadPro.map" >> $out/share/texmf/web2c/updmap.cfg
      #
      #     # Regenerate .map files.
      #     perl `type -P updmap.pl` --sys
      #   '';
    });
in {
  home.packages = [
    texlive
    config.nur.repos.clefru.minionpro
  ];
}
