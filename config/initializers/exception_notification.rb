Swprototype::Application.config.middleware.use ExceptionNotifier ,
:email_prefix => "[Swigbig Error] ",
:sender_address => %{"notifier" <notifier@swigbig.com>},
:exception_recipients => %w{hendra@41studio.com syafik@41studio.com angga@41studio.com}