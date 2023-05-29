# -*- coding: utf-8 -*-
# @Time    : 2023/5/26
# @Author  : Naihe
# @Email   : 239144498@qq.com
# @File    : api.py
# @Software: PyCharm
from fastapi import FastAPI
from starlette.staticfiles import StaticFiles
from starlette.templating import Jinja2Templates

from src.config.setupsetting import static_url_prefix, static_dir, jinja2_templates_dir
from src.routers.api import router
from src.task.task import log_startup

app = FastAPI(title="ClipSync")

app.add_event_handler('startup', log_startup)
app.include_router(router)

# 静态资源目录
app.mount(static_url_prefix, StaticFiles(directory=static_dir), name="static")
# 挂载 jinja2 模板引擎
app.state.jinja = Jinja2Templates(directory=jinja2_templates_dir)
