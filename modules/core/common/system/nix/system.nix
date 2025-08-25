{self, ...}: {
  system = {
    # Globally declare the configurationRevision from shortRev if the git tree is clean,
    # or from dirtyShortRev if it is dirty. This is useful for tracking the current
    # configuration revision in the system profile.
    configurationRevision = self.shortRev or self.dirtyShortRev;
  };
  environment.etc."flake-source".source = self;
}
