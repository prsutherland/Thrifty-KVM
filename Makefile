all : build/80-thrifty-kvm.rules

build/80-thrifty-kvm.rules :
	mkdir build
	cp src/80-thrifty-kvm.rules build/80-thrifty-kvm.rules.scratch
	awk '{ gsub(/\$$\(PREFIX\)/, "$(PREFIX)"); print }' build/80-thrifty-kvm.rules.scratch > build/80-thrifty-kvm.rules.partial
	awk '{ gsub(/\$$\(DESTDIR\)/, "$(DESTDIR)"); print }' build/80-thrifty-kvm.rules.partial > build/80-thrifty-kvm.rules

.PHONY : install uninstall clean

install : build/80-thrifty-kvm.rules
	install --directory "$(DESTDIR)$(PREFIX)/sbin/"
	install --compare --mode 700 src/on-keyboard-plug.sh "$(DESTDIR)$(PREFIX)/sbin/"
	install --compare --mode 700 src/on-keyboard-unplug.sh "$(DESTDIR)$(PREFIX)/sbin/"
	install --directory "$(DESTDIR)/etc/udev/rules.d/"
	install --compare --mode 644 build/80-thrifty-kvm.rules "$(DESTDIR)/etc/udev/rules.d"

uninstall :
	rm "$(DESTDIR)$(PREFIX)/sbin/on-keyboard-plug.sh"
	rm "$(DESTDIR)$(PREFIX)/sbin/on-keyboard-unplug.sh"
	rm "$(DESTDIR)/etc/udev/rules.d/80-thrifty-kvm.rules"

clean :
	rm --recursive --force build/
