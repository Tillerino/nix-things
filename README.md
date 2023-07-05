# nix-things

# OpenGL

https://github.com/guibou/nixGL

```
nix-channel --add https://github.com/guibou/nixGL/archive/main.tar.gz nixgl && nix-channel --update
nix-env -iA nixgl.auto.nixGLDefault   # or replace `nixGLDefault` with your desired wrapper
```
check:

`nix-shell -p glxinfo --run "nixGL glxinfo"`

