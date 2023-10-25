# کایسی

یک اسکریپت برای راه اندازی تونل معکوس بین دو سرور


تونل معکوس یکی از روش های برقراری تونل میان دو سرور است و می توان گفت بیشترین کاربرد را برای افرادی دارد که در کشور هایی با سانسور شدید مانند ایران و روسیه و جین و... افدام به راه اندازی سرویس های ضد سانسور می کنند.

برتری تونل معکوس نسیت به سایر روش های برقراری تونل این است که در صورت فیلتر بودن یا شدن سرور خارجی/دوم همچنان بدون مشکل کار میکند و عملا مشکل فیلتر بودن/شدن سرور های خارجی را حل کرده است.
تمامی مراحل اجرای تونل معکوس قبلا در [این لینک](https://github.com/slayer76/Remote-SSH-Tunnel-Farsi) توضیح داده شده اند و اسکریپت کایسی ساخته شد تا اجرای این مراحل را سریعتر و برای کاربران غیرفنی ساده تر کند.

## برخی از قابلیت ها

- اجرا با یک فرمان
- کاربر پسند
- عالی برای کاربران غیرفنی
- ایجاد کرون جاب برای افزایش پایداری تونل
- و...

## اجرا

دستور پایین را جهت اجرای اسکریپت در سرور خارجی/فیلترشده وارد نمایید

```bash
    bash <(curl -s https://raw.githubusercontent.com/mobinalipour/Qaysi/main/Qaysi.sh)
```
بهتر است سرور را بعد اجرای اسکریپت یک بار ریستارت نمایید.
    
## استفاده

مطمئن شوید این اسکریپت را در سرور خارجی/فیلترشده اجرا می کنید.

بعد از اجرای این اسکریپت پکیج های مورد نیاز را نصب می کند و سپس اطلاعات سرور داخلی/آزاد را از شما می خواهد و با وارد کردن اطلاعات مورد نیاز اسکریپت شروع به ایجاد و برقراری تونل می کند و بعد از اتمام مراحل انجام شده را نمایش می دهد.

بعد از اتمام کار اسکریپت یک سرویس با نام Qaysi در سرور شما ساخته می شود که شما در آینده  با استفاده از آن و دستورات زیر می توانید پورت های بیشتری را تونل کنید:


``` bash
    systemctl start Qaysi@the_port_you_want
```
``` bash
    systemctl enable Qaysi@the_port_you_want
```

و بعد از آن باید کرون جاب را برای پورت های جدیدی که تونل کرده اید راه اندازی کنید که با دستور زیر می توانید کرون جاب قبلی را ببینید و یک جاب جدید راه اندازی کنید :

```bash
    crontab -e
```

یا می توانید این اسکریپت را یک بار دیگر برای پورت های بیشتر راه اندازی کنید :(

برای بررسی عملکرد صحیح تونل دستور زیر را در -<  سرور  داخلی/آزاد >-  وارد کنید و سپس پورت های تونل شده را مشاهده کنید:


```bash
    lsof -i -P -n | grep LISTEN
```

## با تشکر از 
[محمد حسین قلی نسب](https://github.com/slayer76/Remote-SSH-Tunnel-Farsi)


## دونیت

برای حمایت فقط کافیه به این اسکریپت یک ستاره بدهید :(
