# macOS 配置

在 Apple Silicon Mac 上克隆本仓库，然后按用途运行一条命令。

```sh
./bootstrap.sh work
# 或
./bootstrap.sh personal
```

缺少 Nix 时，脚本使用 [Lix 安装器](https://lix.systems/install/)引导，再按 [nix-darwin 官方流程](https://github.com/nix-darwin/nix-darwin#install)激活配置。安装器可能要求确认，系统激活需要管理员权限。

两套配置共用 `darwin/configuration.nix`，私人 Mac 另加载 `darwin/personal.nix`。激活完成后，在新终端运行 `darwin-version` 验证。

日常修改配置后，在仓库根目录执行。

```sh
sudo darwin-rebuild switch --flake .#personal
```

工作 Mac 将 `.#personal` 换成 `.#work`。升级依赖时运行 `nix flake update`，检查并提交 `flake.lock`。
