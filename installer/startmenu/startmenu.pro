TEMPLATE = aux

INSTALLER = installer_AsteroidsCanvasQML_v_1_0

INPUT = $$PWD/config/config.xml $$PWD/packages
example.input = INPUT
example.output = $$INSTALLER
example.commands = binarycreator -c $$PWD/config/config.xml -p $$PWD/packages ${QMAKE_FILE_OUT}
example.CONFIG += target_predeps no_link combine

QMAKE_EXTRA_COMPILERS += example

OTHER_FILES = README \
packages/org.nepa1234software.asteroidscanvasqml/data/README.txt \
packages/org.nepa1234software.asteroidscanvasqml/meta/package.xml

