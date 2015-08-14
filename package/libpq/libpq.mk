################################################################################
#
# libpq
#
################################################################################

LIBPQ_VERSION = 9.4.4
LIBPQ_SOURCE = postgresql-$(LIBPQ_VERSION).tar.bz2
LIBPQ_SITE = http://ftp.postgresql.org/pub/source/v$(LIBPQ_VERSION)
LIBPQ_LICENSE = PostgreSQL
LIBPQ_LICENSE_FILES = COPYRIGHT
LIBPQ_INSTALL_STAGING = YES

ifneq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
LIBPQ_CONF_OPTS += --disable-thread-safety
endif

ifeq ($(BR2_arcle)$(BR2_arceb)$(BR2_microblazeel)$(BR2_microblazebe)$(BR2_nios2)$(BR2_xtensa),y)
LIBPQ_CONF_OPTS += --disable-spinlocks
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
LIBPQ_DEPENDENCIES += readline
else
LIBPQ_CONF_OPTS += --without-readline
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
LIBPQ_DEPENDENCIES += zlib
else
LIBPQ_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_TZDATA),y)
LIBPQ_DEPENDENCIES += tzdata
LIBPQ_CONF_OPTS += --with-system-tzdata=/usr/share/zoneinfo
else
LIBPQ_DEPENDENCIES += host-zic
LIBPQ_CONF_ENV += ZIC=$$(ZIC)
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBPQ_DEPENDENCIES += openssl
LIBPQ_CONF_OPTS += --with-openssl
endif

define LIBPQ_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D)/src/interfaces/libpq install
endef

$(eval $(autotools-package))
