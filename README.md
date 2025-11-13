# voicetruth /Голос Правды/

Приложение после пересоздания с последними версиями флаттера и плагинов, а также перевода на null safety.

КОМПИЛИРОВАТЬ НА Flutter 2.2.3, на 2.5 не собирается!!!
Проблема в пакете audio_service, исправление еще в бетте.

Также не работает пакет flutter_inner_drawer в режиме null-safety.
Пришлось использовать стандартный дровер флаттера, пока не будут закрыты проблемы:
https://githubmemory.com/repo/Dn-a/flutter_inner_drawer/issues/70
https://github.com/Dn-a/flutter_inner_drawer/pull/69

## Соглашение о кодировании

- Длина строки 120 символов.

- Если файл экспортирует только один класс - имя файла совпадает с именем класса, а именно в формате UpperCamelCase.dart.
Линтер несогласен, но не вижу смысла плодить имена сверх необходимого.

- В классах моделей поля, написанные маленькими буквами соответствуют полям JSON, а поля в стиле lowerCamelCase - уже обработанным данным. Например: String starttime - пришло из JSON, и рядом - DateTime startTime - значение после парсинга. Это не я придумал, таково наследие предков, прошу отнестись с пониманием.(c) Исправлю позже.



VERIFY ARGS {name: Auth#phoneCodeSent, verificationId: AJOnW4QgpZIOuGqBrbv2W2bGB5RRAGz8t231eu0q2Bbdps8TTNL9AdBH9YkcGPburYFXZbu-QboBWtrWD-jtIsjp5UxzWhOal-wqFYLTs7b6XCrjIDP67ltjFwxYOl1e88r7D8SAH6CfPiIgEARHcZSbEzz78qWpUg}
VERIFY ARGS {name: Auth#phoneVerificationFailed, error: {message: Invalid token., details: {message: Invalid token., additionalData: {}, code: invalid-app-credential}}}