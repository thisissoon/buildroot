################################################################################
#
# libpq
#
################################################################################

PG_CONFIG_VERSION = 9.4.4
PG_CONFIG_SOURCE = postgresql-$(PG_CONFIG_VERSION).tar.bz2
PG_CONFIG_SITE = http://ftp.postgresql.org/pub/source/v$(PG_CONFIG_VERSION)
PG_CONFIG_LICENSE = PostgreSQL
PG_CONFIG_LICENSE_FILES = COPYRIGHT
PG_CONFIG_INSTALL_STAGING = NO

ifneq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
PG_CONFIG_CONF_OPTS += --disable-thread-safety
endif

ifeq ($(BR2_arcle)$(BR2_arceb)$(BR2_microblazeel)$(BR2_microblazebe)$(BR2_nios2)$(BR2_xtensa),y)
PG_CONFIG_CONF_OPTS += --disable-spinlocks
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
PG_CONFIG_DEPENDENCIES += readline
else
PG_CONFIG_CONF_OPTS += --without-readline
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
PG_CONFIG_DEPENDENCIES += zlib
else
PG_CONFIG_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_TZDATA),y)
PG_CONFIG_DEPENDENCIES += tzdata
PG_CONFIG_CONF_OPTS += --with-system-tzdata=/usr/share/zoneinfo
else
PG_CONFIG_DEPENDENCIES += host-zic
PG_CONFIG_CONF_ENV += ZIC=$$(ZIC)
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
PG_CONFIG_DEPENDENCIES += openssl
PG_CONFIG_CONF_OPTS += --with-openssl
endif

define PG_CONFIG_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/src/bin/pg_config DESTDIR=$(TARGET_DIR) install
endef

$(eval $(autotools-package))
