all:
	@echo "make install - install"
	@echo "make root_instal - root install"
	@echo "make transfer - transfer dotfiles"

install:
	chmod +x ./install.sh
	./install.sh

root_install:
	chmod +x ./install_root.sh
	./install_root.sh

transfer:
	chmod +x ./transfer.sh
	./transfer.sh

