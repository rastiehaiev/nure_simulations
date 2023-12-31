## Комп'ютерні системи імітаційного моделювання
## СПм-22-3, **Растєгаєв Роман Іванович**
### Лабораторна робота №**3**. Використання засобів обчислювального інтелекту для оптимізації імітаційних моделей

### Варіант 6, модель у середовищі NetLogo:
[Rabbits Grass Weeds](http://www.netlogoweb.org/launch#http://www.netlogoweb.org/assets/modelslib/Sample%20Models/Biology/Rabbits%20Grass%20Weeds.nlogo)

### Вербальний опис моделі:
Симуляція основних принципів взаємодій у спільноті організмів. Модель передбачає існування трьох основних компонентів в екосистемі: трава (надає їжу кроликам), кролики (харчуються травою як своєю основною їжею) та бурʼян (рослини, які можуть конкурувати з травою за ресурси, але не є головною їжею для кроликів). 
У цій моделі екосистеми взаємодії між цими трьома компонентами можуть бути використані для вивчення екологічних концепцій, таких як динаміка популяцій, взаємодія хижак-жертва і вплив конкуренції між видами рослин.

### Керуючі параметри:
- **number-of-rabbits** визначає кількість агентів у середовищі моделювання, тобто, в даній моделі, початкова кількість кроликів.
- **birth-threshold** визначає кількість енергії, необхідної агенту для репродукції.
- **grass-grow-rate** визначає темп зростання трави з кожним ігровим тактом.
- **grass-energy** визначає кількість енергії, яку отримує кролик споживаючи траву.
- **weeds-grow-rate** визначає темп зростання бурʼяну в кожному ігровому такті.
- **weeds-energy** визначає кількість енергії, яку отримує кролик споживаючи бурʼян.

### Показники роботи системи:
- поточна кількість трави,
- поточна кількість бурʼяну,
- поточна популяція кроликів.

### Налаштування середовища BehaviorSearch:

**Обрана модель**<br>
Візьмемо модифікований варіант моделі з ЛР №2. Зміни моделі, які були додані в ЛР №2:
- Додано можливість отруїтися при поїданні бур'янів (зазначена у внутрішніх параметрах, як певна вірогідність). Захворілий кролик не може харчуватися, переміщатися і розмножуватися, позначається іншим кольором і залишається хворим на 3 такти модельного часу.
- Додано поділ кроликів на самців та самок.
- Поява нових кроликів має вимагати не тільки ситості, а й здоров'я, та присутності в одній із сусідніх клітин іншого ситого здорового кролика протилежної статі.
- Поява потомства відбувається із ймовірністю 50%.
- Додано кожному кролику "вік" - кількість тактів, після яких кролик "помирає".
- Додано можливість народжувати тільки кроликам жіночої статі (рандомно одного або двох). Кролики чоловічої статі тільки втрачають енергію.

**Параметри моделі**<br>
*Параметри та їх діапазони були автоматично вилучені середовищем BehaviorSearch із вибраної імітаційної моделі, для цього скористаємось кнопкою «Load parameter ranges from model interface»*:
<pre>
["grass-grow-rate" [0 1 20]]
["weeds-grow-rate" [0 1 20]]
["grass-energy" [0 0.5 10]]
["weed-energy" [0 0.5 10]]
["number" [0 150 500]]
["birth-threshold" [5 1 20]]
</pre>

*Нижнє значення кількість енергії, необхідної кролику для репродукції, було збільшено з 0 до 5 для того, щоб зімітувати більш реальний сценарій.*

**Міра фітнес-функції**<br>
В якості міри для фітнес-функції використано значення популяції кроликів в середовищі існування. Вираз цієї міри узято з налаштувань графіка імітаційної моделі в середовищі NetLogo:
<pre>
count rabbits
</pre>

Кількість кроликів в середовищі існування має враховуватися **в середньому** за весь період симуляції тривалістю 500 тактів (адже в кожному такті це значення відрізняється), починаючи з 0 такту симуляції (параметр **Step limit**).
Цього можна досягти за допомоги параметру "**Measure if**" зі значенням *true*.
Іноді має сенс не враховувати деякі такти через хаос у деяких моделях на початку їх використання. Для цього можна було б вказати специфічні умови в параметрі "**Measure if**".

Параметри "**Setup**" та "**Go**" мають вказувати на відповідні процедури ініціалізації та запуску у логіці моделі.
BehaviorSearch в процесі роботи замість користувача запускає ці процедури.
Параметр зупинки за умовою ("**Stop if**") в цій ЛР не використовується.

Скриншот панелі налаштування параметрів приведено на малюнку:<br>
![Вкладка налаштувань параметрів](screenshot-settings-parameters.png)<br>

**Налаштування цільової функції** (Search Objective)<br>
Метою підбору параметрів імітаційної моделі є **максимізація** значення середньої популяції кроликів в середовищі існування (тобто знайти такі параметри налаштуванн моделі, при яких значення середньої популяції кроликів найбільше).
Ми вказуємо це за допомогою значення **Maximize Fitness** в параметрі "**Goal**".
При чому, важливо, що нас має цікавити не значення популяції в окремий момент симуляції, а середнє значення протягом всієї симуляції, тривалість якої 500 кроків.
Для цього в параметрі "**Collected measure**" вказуємо значення **MEAN_ACROSS_STEPS**.
Щоб уникнути спотворення результатів через випадкові значення, що використовуються в логіці самої імітаційної моделі, **кожна симуляція повторюється по 10 разів**, результат розраховується як **середнє арифметичне**.

Скриншот панелі налаштування параметрів цільової функції:<br>
![Вкладка налаштувань параметрів цільової функції](screenshot-settings-objective.png)<br>

**Налаштування алгоритму пошуку** (Search Algorithm)<br>
На цьому етапі було визначено модель, налаштовані її параметри, і вибрано міру ефективності, що лежить в основі функції пристосованості, 
що дозволяє оцінити "якість" кожного з варіанта рішення, що перевіряється BehaviorSearch.
У ході дослідження будуть використовуватися два алгоритми: Випадковий пошук (RandomSearch) і Простий генетичний алгоритм (StandardGA).
Для цих алгоритмів необхідно вказати "**Evaluation limit**" (число ітерацій пошуку, у разі GA - це буде число поколінь), та "**Search Space Encoding Representation**" (спосіб кодування варіанта рішення).
Загальноприйнятого "кращого" способу кодування немає, неохідно визначити, які підходять для поточної моделі.
Параметр "**Use fitness caching**" впливає тільки на продуктивність.

Налаштування *RandomSearch* алгоритму пошуку:<br>
![Вкладка налаштувань пошуку](screenshot-settings-search-random.png)<br>

Параметри, специфічні для генетичного алгоритму, можна використовувати за замовчуванням, якщо це не перешкоджає отриманню результату.<br>

Налаштування *StandardGA* алгоритму пошуку:<br>
![Вкладка налаштувань пошуку](screenshot-settings-search-ga.png)<br>

### Результати використання BehaviorSearch:

Було проведено експерименти з усіма доступними налаштуваннями параметра "**Search Space Encoding Representation**".
Нижче наведено таблицю результатів Fitness:

<table>
<thead>
<tr><th></th><th>GrayBinary</th><th>StandardBinary</th><th>MixedType</th><th>RealHypercube</th></tr>
</thead>
<tbody>
<tr><td>RandomSearch</td><td>484.9</td><td>484.9</td><td>478.9</td><td>456.2</td></tr>
<tr><td>StandardGA</td><td>496.2</td><td>579.6</td><td>603.9</td><td>591.7</td></tr>
</tbody>
</table>

Нижче представлені скриншоти найуспішніших експериментів (тих, в яких ми отримали найбільше значення Fitness).

Результат пошуку параметрів імітаційної моделі, використовуючи **випадковий пошук** (RandomSearch, GrayBinaryChromosome):<br>
![Вікно запуску пошуку](screenshot-result-random-GrayBinary.png)<br>
Результат пошуку параметрів імітаційної моделі, використовуючи **генетичний алгоритм** (StandardGA, RealHypercubeChromosome):<br>
![Вікно запуску пошуку](screenshot-result-ga-MixedType.png)<br>

Для наглядності доданий результат роботи моделі в середовищі NetLogo з параметрами найуспішнішого експерименту:<br>
![Вікно запуску NetLogo](screenshot-NetLogo.png)<br>
