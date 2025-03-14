python -m nuitka \
        --standalone \
        --nofollow-import-to=pytest \
        --python-flag=nosite,-O \
        --plugin-enable=anti-bloat,implicit-imports,data-files,pylint-warnings \
        --clang \
        --warn-implicit-exceptions \
        --warn-unusual-code \
        --prefer-source-code \
        --show-memory \
        --include-module=myapp \
        --main=myapp/main.py


python -m nuitka --standalone --onefile --python-flag=no_site --include-module=app -o microservice.bin main.py


pipenv install
pipenv run python -m nuitka --include-module=app --follow-imports --standalone test1.py

python -m nuitka --mingw64 --standalone --windows-disable-console --plugin-enable=pyside6 --windows-icon-from-ico=static/img/logo.png --linux-onefile-icon=static/img/logo.png --onefile --python-flag=no_site --include-module=app -o ClipSync tray_main.py

python -m nuitka --mingw64 --standalone --plugin-enable=pyside6 --windows-icon-from-ico=static/img/logo.png --linux-onefile-icon=static/img/logo.png --onefile --python-flag=no_site --include-module=app -o ClipSync tray_main.py

