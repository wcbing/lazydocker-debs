自行打包的 [lazydocker](https://github.com/jesseduffield/lazydocker)，供 Debian 或其他发行版上使用。

Self-packaged [lazydocker](https://github.com/jesseduffield/lazydocker) for use on Debian or other distro.


## Usage/用法

```sh
echo "deb [trusted=yes] https://github.com/wcbing-build/lazydocker-debs/releases/latest/download ./" |
    sudo tee /etc/apt/sources.list.d/lazydocker.list
sudo apt update
```