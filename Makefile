UWE ?= uwe
TARGET := target

clean:
	@rm -rf $(TARGET)
	@mkdir $(TARGET)

new-project-plugin:
	@(cd $(TARGET) && $(UWE) new project-plugin std::blueprint::default)
	@$(UWE) build $(TARGET)/project-plugin

new-project-git:
	@(cd $(TARGET) && $(UWE) new project-git --git https://github.com/uwe-app/blueprints --prefix=default)
	@$(UWE) build $(TARGET)/project-git

new: new-project-plugin new-project-git

default:
	@(cd $(TARGET) && $(UWE) new default-project)
	@$(UWE) build $(TARGET)/default-project
	@(cd $(TARGET)/default-project && $(UWE) clean)

blog:
	@(cd $(TARGET) && $(UWE) new blog-project blog)
	@$(UWE) build $(TARGET)/blog-project
	@(cd $(TARGET)/blog-project && $(UWE) clean)

deck:
	@(cd $(TARGET) && $(UWE) new deck-project deck)
	@$(UWE) build $(TARGET)/deck-project
	@(cd $(TARGET)/deck-project && $(UWE) clean)

blueprints: default blog deck

getting-started:
	@(cd $(TARGET) && $(UWE) new basic-website)
	@(cd $(TARGET)/basic-website \
		&& echo "Running dev server..." \
		&& UWE=$(UWE) ../../dev-server.sh && sleep 2 \
		&& echo "Stopping dev server..." \
		&& kill `cat dev-server.pid` \
		&& $(UWE) build)

# FIXME: use: uwe new blog blog - to create blog in workspace context
create-workspace:
	@(cd $(TARGET) && mkdir example.com)
	@(cd $(TARGET)/example.com \
		&& $(UWE) new website \
		&& $(UWE) new blog \
		&& $(UWE) new docs \
		&& cp -f ../../fixtures/workspace/site.toml . \
		&& cp -f ../../fixtures/workspace/website.toml ./website/site.toml \
		&& cp -f ../../fixtures/workspace/blog.toml ./blog/site.toml \
		&& cp -f ../../fixtures/workspace/docs.toml ./docs/site.toml \
		&& $(UWE) build)

using-javascript-transpiler:
	@(cd $(TARGET) && $(UWE) new esbuild-hook)
	@(cd $(TARGET)/esbuild-hook \
		&& cp -f ../../fixtures/esbuild-hook/package.json . \
		&& yarn add esbuild --dev \
		&& cp -f ../../fixtures/esbuild-hook/site.toml . \
		&& cp -f ../../fixtures/esbuild-hook/index.md ./site \
		&& mkdir -p site/src \
		&& cp -f ../../fixtures/esbuild-hook/main.js ./site/src \
		&& $(UWE) build --exec)

adding-integration-tests:
	@(cd $(TARGET) && $(UWE) new test-project)
	@(cd $(TARGET)/test-project \
		&& $(UWE) build \
		&& yarn add cypress --dev \
		&& $(UWE) task init-test \
		&& $(UWE) test)

tutorials: getting-started create-workspace using-javascript-transpiler adding-integration-tests

test: clean new blueprints tutorials

.PHONY: clean test blueprints tutorials
