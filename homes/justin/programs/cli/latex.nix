{
  lib,
  pkgs,
  self,
  config,
  ...
}: let
  #minionpro.pkgs = [pkgs.nur.repos.clefru.minionpro];
  texlive =
    pkgs.lib.overrideDerivation (pkgs.texlive.combine {
      inherit
        (pkgs.texlive)
        scheme-medium
        cancel
        dinbrief
        german
        standalone
        preview
        mnsymbol
        crimson
        xkeyval
        mweights
        ucs
        totpages
        booktabs
        lm
        #ms
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
        latexmk
        ;
      #inherit minionpro;
    }) (oldAttrs: {
      # postBuild =
      # ''
      #   # Save the udpmap.cfg because texlive.combine removes it.
      #   cat $out/share/texmf/web2c/updmap.cfg > $out/share/texmf/web2c/updmap.cfg.1
      # ''
      # + oldAttrs.postBuild
      # oldAttrs.postBuild
      # + ''
      #   updmap --sys --enable Map=MinionPro.map
      #   updmap --sys
      # '';
    });
in {
  home.packages = [
    texlive
    #pkgs.nur.repos.clefru.minionpro
  ];
}
