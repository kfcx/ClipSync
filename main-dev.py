# -*- coding: utf-8 -*-
# @Time    : 2023/5/27
# @Author  : Naihe
# @Email   : 239144498@qq.com
# @File    : main.py
# @Software: PyCharm
import sys

from multiprocessing import Process

from PySide6.QtWidgets import QMenu
from PySide6.QtGui import QIcon, QAction, QDesktopServices
from PySide6.QtWidgets import QApplication, QSystemTrayIcon
from main import main


class SystemTrayIcon(QSystemTrayIcon):
    def __init__(self, parent=None):
        super(SystemTrayIcon, self).__init__(parent)
        self.p = None
        self.state = True

        # 设置托盘图标和提示文本
        self.setIcon(self.get_icon(self.state))
        self.setToolTip("ClipSync")

        # 创建托盘菜单
        tray_menu = QMenu()

        # 开启/关闭同步
        self.toggle_action = QAction(
            "关闭同步" if self.state else "开启同步",
            self,
            triggered=self.toggle_app
        )
        self.toggle_action.setData(self.state)
        tray_menu.addAction(self.toggle_action)

        # 设置
        self.home_action = QAction("主界面", self, triggered=self.open_settings)
        self.home_action.setEnabled(self.state)
        tray_menu.addAction(self.home_action)

        # 关于
        self.about_action = QAction("关于", self, triggered=self.about_app)
        tray_menu.addAction(self.about_action)

        # 退出程序
        exit_action = QAction("退出程序", self, triggered=self.exit_app)
        tray_menu.addAction(exit_action)

        # 设置托盘菜单
        self.setContextMenu(tray_menu)

        # 显示托盘图标
        self.show()

        self.start_sync_clipboard()

    def get_icon(self, state):
        if state:
            return QIcon("static/img/logo_green.png")
        else:
            return QIcon("static/img/logo_red.png")

    def start_sync_clipboard(self):
        self.p = Process(target=main, daemon=True)
        self.p.start()

    def stop_sync_clipboard(self):
        try:
            self.p.terminate()
        except AttributeError as e:
            pass

    def toggle_app(self):
        data = not self.toggle_action.data()
        self.toggle_action.setData(data)
        self.home_action.setEnabled(data)
        self.setIcon(self.get_icon(data))
        if data:
            self.toggle_action.setText("关闭同步")
            self.start_sync_clipboard()
        else:
            self.toggle_action.setText("开启同步")
            self.stop_sync_clipboard()

    def open_settings(self):
        QDesktopServices.openUrl("http://localhost:8000")

    def about_app(self):
        QDesktopServices.openUrl("https://github.com/239144498/ClipSync")

    def exit_app(self):
        QApplication.instance().quit()


if __name__ == "__main__":
    app = QApplication(sys.argv)

    # 检查系统是否支持系统托盘
    if not QSystemTrayIcon.isSystemTrayAvailable():
        QApplication.setQuitOnLastWindowClosed(True)
        main()
    else:
        tray_icon = SystemTrayIcon()
        sys.exit(app.exec())

    # 1. **打开应用**：打开应用的主界面，展示剪贴板历史记录、同步状态等信息。
    # 2. **剪贴板历史**：快速访问最近的剪贴板内容，方便用户查看和选择。
    # 3. **清空剪贴板**：一键清空当前剪贴板内容。
    # 4. **同步设置**：用户可以在此设置同步选项，例如自动同步、手动同步、同步频率等。
    # 5. **账户管理**：允许用户登录、登出、切换账户以及查看当前登录的账户信息。
    # 6. **隐私设置**：提供关于数据加密、安全传输等隐私选项的设置。
    # 7. **帮助与反馈**：提供用户帮助文档、联系方式和问题反馈渠道。
    # 8. **检查更新**：检查应用的最新版本并进行更新。
    # 9. **启动时自动运行**：设置应用是否在系统启动时自动运行。
    # 10. **退出**：完全退出云剪贴板同步应用。
