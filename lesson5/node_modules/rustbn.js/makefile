SHELL := /bin/bash

all:
	cargo build --target=asmjs-unknown-emscripten --release
	mkdir -p lib
	find target/asmjs-unknown-emscripten/release -type f -name "rustbn-js.js" | xargs -I {} cp {} lib/index.asm.js
	sed -ibak 's/run()$$/Module\["arguments"\]=\[\];run();module\.exports=Module;/' lib/index.asm.js

wasm:
	cargo build --target=wasm32-unknown-emscripten --release
	mkdir -p exp
	find target/wasm32-unknown-emscripten/release/deps -type f -name "*.wasm" | xargs -I {} cp {} exp/rustbn.wasm
	find target/wasm32-unknown-emscripten/release/deps -type f ! -name "*.asm.js" -name "*.js" | xargs -I {} cp {} exp/index.wasm.js