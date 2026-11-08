{ ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.settings.experimental-features = "nix-command flakes";

  # 当前配置无需自定义 sudo 的 PAM 设置。
  security.pam.services.sudo_local.enable = false;

  # 兼容性版本。升级依赖时保持此值，变更前先阅读 darwin-rebuild changelog。
  system.stateVersion = 6;
}
