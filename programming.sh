#/bin/bash

sudo dnf install golang python3 python3-pip maven

# Sdkman
curl -s "https://get.sdkman.io" | bash

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
