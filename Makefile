BIN_UWE ?= uwe
TARGET := target

clean:
	@rm -rf $(TARGET)
	@mkdir $(TARGET)

getting-started:
	@(cd $(TARGET) && $(BIN_UWE) new basic-website)
	@(cd $(TARGET)/basic-website \
		&& echo "Running dev server..." \
		&& BIN_UWE=$(BIN_UWE) ../../dev-server.sh && sleep 2 \
		&& echo "Stopping dev server..." \
		&& kill `cat dev-server.pid` \
		&& $(BIN_UWE) build)

using-javascript-transpiler:
	@(cd $(TARGET) && $(BIN_UWE) new esbuild-hook)
	@(cd $(TARGET)/esbuild-hook \
		&& cp -f ../../fixtures/esbuild-hook/package.json . \
		&& yarn add esbuild --dev \
		&& cp -f ../../fixtures/esbuild-hook/site.toml . \
		&& cp -f ../../fixtures/esbuild-hook/index.md ./site \
		&& mkdir -p site/src \
		&& cp -f ../../fixtures/esbuild-hook/main.js ./site/src \
		&& $(BIN_UWE) build --exec)

adding-integration-tests:
	@(cd $(TARGET) && $(BIN_UWE) new test-project)
	@(cd $(TARGET)/test-project \
		&& $(BIN_UWE) build \
		&& yarn add cypress --dev \
		&& $(BIN_UWE) task init-test \
		&& $(BIN_UWE) test)

tutorials: getting-started using-javascript-transpiler adding-integration-tests

test: clean tutorials

.PHONY: clean test tutorials
