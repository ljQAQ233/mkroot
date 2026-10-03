# mkroot

`mkroot` 是 [TextOS](https://github.com/ljQAQ233/textos-dev) 的 "附属" 项目.

> 我的本意是模仿 **buildroot** 来做一个构建器, 结果没有完全用它的模式

# 构建

```shell
cp configs/hello_defconfig
make menuconfig
```

构建工具链:

```shell
make toolchain
```

构建软件包:

```shell
make package
```

配置镜像:

```shell
make preimage
```

对 `image.item` 文件做删减后, 留下的文件将进入镜像:

```shell
make mkimage
```

---

使用 qemu 启动:

```shell
make qemu-efi # efi 启动
make qemu-emu # -kernel 直接装载
```

---

清理不必多说:

- `make clean`
- `make stpclean`
- `make distclean`

# 架构

```
├── Config.in  Kconfig 入口
├── configs    Kconfig 参考配置
├── output     输出文件夹
├── scripts    脚本
├── image.item 最终镜像的定制文件
├── package    各种软件包
├── osimage    镜像
└── toolchain  工具链
```

---

1. **x86 (64)** 极其特殊, 所以直接使用 host 的 gcc 来编译

2. **newlib** 作为默认的 libc 参与静态链接

---

试着把 textos kernel 与 ovmf 从构建系统里面隔离了, 为此 在 github 上建立了 workflow 来构建 [textos kernel](https://github.com/ljQAQ233/textos-dev/actions/) 与 [edk2 ovmf](https://github.com/ljQAQ233/ovmf-prebuilt/actions/).

# 软件版本

- `GCC` - `15.3.0`
- `QEMU` - `10.1.2`
