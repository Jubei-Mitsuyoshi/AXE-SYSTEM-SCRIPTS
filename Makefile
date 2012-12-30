DIRS := \
	/etc/runit \
	/usr/sbin \
	/etc/runit/runsvdir/current/getty-1 \
	/etc/runit/runsvdir/current/getty-2 \
	/etc/runit/runsvdir/current/getty-1/log \
	/etc/runit/runsvdir/current/getty-2/log \
	/etc/runit/runsvdir/current/dbus \
	/etc/runit/runsvdir/current/dbus/log \
	/etc/logrotate.d \
	/etc/tmpfiles.d \
	/usr/lib/tmpfiles.d \
	/etc/binfmt.d \
	/usr/lib/binfmt.d \
	/usr/lib/axeinit \
	/usr/share/man/man7 \
	/usr/share/man/man5 \
	/usr/share/man/man8
	
MAN_PAGES := \
	binfmt.d.5

all: doc

installdirs:
	install -dm755 $(foreach DIR, $(DIRS), $(DESTDIR)$(DIR))

install: installdirs doc
	install -m644 -t $(DESTDIR)/etc/logrotate.d bootlog
	install -m644 -t $(DESTDIR)/etc/runit axe-init.conf
	install -m644 tmpfiles.conf $(DESTDIR)/usr/lib/tmpfiles.d/arch.conf
	install -m755 -t $(DESTDIR)/usr/lib/axeinit binfmt tmpfiles
	install -m755 -t $(DESTDIR)/etc/runit 1 2 3 common
	install -m755 -t $(DESTDIR)/usr/sbin update-service
	install -m755 -t $(DESTDIR)/etc/runit/runsvdir/current/getty-1 base-services/getty-1/run base-services/getty-1/finish
	install -m755 -t $(DESTDIR)/etc/runit/runsvdir/current/getty-2 base-services/getty-2/run base-services/getty-2/finish
	install -m755 -t $(DESTDIR)/etc/runit/runsvdir/current/dbus base-services/dbus/run base-services/dbus/finish
	
#	install -m644 -t $(DESTDIR)/usr/share/man/man7 $(filter %.7, $(MAN_PAGES))
#	install -m644 -t $(DESTDIR)/usr/share/man/man5 $(filter %.5, $(MAN_PAGES))
#	install -m644 -t $(DESTDIR)/usr/share/man/man8 $(filter %.8, $(MAN_PAGES))


%.5: %.5.txt
	a2x -d manpage -f manpage $<

%.7: %.7.txt
	a2x -d manpage -f manpage $<

%.8: %.8.txt
	a2x -d manpage -f manpage $<

doc: $(MAN_PAGES)

clean:
	rm -f doc: $(MAN_PAGES)


.PHONY: all installdirs install doc clean