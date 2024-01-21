prev:
prev.qtcreator.override {
  llvmPackages = prev.llvmPackages_17;
  qttools = prev.qt6.qttools.override { llvmPackages = prev.llvmPackages_17; };
}
