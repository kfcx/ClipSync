# -*- coding: utf-8 -*-
# @Time    : 2023/5/31
# @Author  : Naihe
# @Email   : 239144498@qq.com
# @File    : build.py
# @Software: PyCharm
# -*coding=utf-8
import os
import shutil


def build(main, method):
    parameters = ['python -m nuitka',
                  '--standalone',  # 独立模式
                  '--mingw64',  # 强制使用MinGW64编译器
                  '--nofollow-imports',  # 不导入任何模块
                  '--plugin-enable=pyside6',  # 导入PyQt
                  '--follow-import-to=utils',  # 递归指定的模块或包
                  '--windows-icon-from-ico=static/img/logo.png',
                  '--linux-onefile-icon=static/img/logo.png',
                  # '--onefile',  # 生成单个可执行文件
                  # '--python-flag=no_site',  # 不导入site模块
                  # '--include-module=app',  # 包含指定的模块或包
                  # '--windows-disable-console',  # 禁用控制台窗口
                  # '-o ClipSync tray_main.py'
                  # '--windows-icon-from-ico=favicon.ico',  # 设置图标
                  ]
    if method == "0":
        path = os.path.join(os.getcwd(), output_dir, 'debug')
        parameters.append(f'--output-dir="{path}"')  # 指定最终文件的输出目录
    elif method == "1":
        path = os.path.join(os.getcwd(), output_dir, 'release')
        parameters.append("--windows-disable-console")  # 禁用控制台窗口
        # parameters.append("--windows-uac-admin")  # UAC
        parameters.append(f'--output-dir="{path}"')  # 指定最终文件的输出目录
    else:
        raise ValueError
    # nuitka
    os.system(f"{' '.join(parameters)} {main}.py")
    return os.path.join(path, main + '.dist', main + '.exe')


def movefile(src_path):
    dst_path = os.path.join(output_dir, 'publish')
    os.makedirs(dst_path, exist_ok=True)
    shutil.copy(src_path, os.path.join(dst_path, os.path.basename(src_path)))


if __name__ == "__main__":
    # enter = 'ClipSync'
    enter = 'main_tray'
    output_dir = os.path.join(os.getcwd(), 'build_file')
    os.makedirs(output_dir, exist_ok=True)
    exe_path = build(enter, input("[Debug(0) / Release(1)]："))
    print(exe_path)
    movefile(exe_path)
