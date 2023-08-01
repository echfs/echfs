project('echfs', 'c', default_options: ['warning_level=2', 'optimization=3','prefix=/usr/local'])

add_project_arguments('-pipe', language: 'c')
cc = meson.get_compiler('c')
nasm = find_program('nasm')
objcopy = find_program('objcopy')

utils_files = ['echfs-utils.c', 'part.c']
fuse_files = ['echfs-fuse.c', 'part.c']
mkfs_files = ['mkfs.echfs.c']

if get_option('utils').enabled()
  uuid = cc.find_library('uuid')
  executable('echfs-utils', utils_files, dependencies: [uuid], install: true, install_dir: 'bin')
endif

if get_option('fuse').enabled()
  fuse = cc.find_library('fuse3')
  executable('echfs-fuse', fuse_files, dependencies: [fuse], install: true, install_dir: 'bin')
endif

if get_option('mkfs').enabled()
  boot_bin = custom_target('boot_bin',
                           output: 'boot.bin',
                           input: 'boot.asm',
                           command: [nasm, '-fbin', '-o', '@OUTPUT@', '@INPUT@'])
  boot_obj = custom_target('boot_obj',
                           output: 'boot.o',
                           input: boot_bin,
                           command: [objcopy, '-B', 'i8086', '-I', 'binary', '-O',
                                     'default', '@INPUT@', '@OUTPUT@'])
  executable('mkfs.echfs', mkfs_files, boot_obj, install: true, install_dir: 'bin')
endif
