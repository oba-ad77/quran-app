import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════
//  سيرة الشيخ — العلّامة محمد بن عبد الله الإمام
//  نسخة كاملة: بطاقة + ExpansionTiles + Timeline يومي + كتب
// ═══════════════════════════════════════════════════════════

class SheikhScreen extends StatelessWidget {
  const SheikhScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nightDeep,
      appBar: AppBar(
        backgroundColor: AppColors.nightDeep,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.mishkatGold),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.mishkatGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: AppColors.mishkatGold,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'نبذة عن الشيخ',
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.moonCream,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
        children: const [
          _HeaderCard(),
          SizedBox(height: 18),
          _BioSection(
            icon: Icons.cake_rounded,
            title: 'المولد والنسب',
            initiallyExpanded: true,
            content:
                'هو الشيخ العلّامة محمد بن عبد الله بن حسين بن طاهر بن علي '
                'بن غازي الرِّيمي، الملقّب بـ«الإمام أبي نصر».\n\n'
                'وُلد عام ١٣٨٠ هجرية، الموافق ١٩٦٠ ميلادية تقريبًا، في قريته '
                'المعروفة بقرية «السهل»، عزلة «الضَّبارة»، ناحية «كسمة»، '
                'التابعة لمحافظة «رَيمة».',
          ),
          _BioSection(
            icon: Icons.menu_book_rounded,
            title: 'نشأته وطلبه للعلم',
            content:
                'نشأ شيخنا في قريته، ولم تكن القرى في تلك الأيام على ما هي '
                'عليه اليوم من وجود المدارس والتعليم وغير ذلك، خاصةً بلاد '
                'الشيخ وما شابهها من المناطق النائية جدًّا؛ فهي بلاد جبلية '
                'وعورة، فنادرًا ما يأتي إليها المعلمون.\n\n'
                'فبدأ شيخنا بتعلّم القرآن الكريم في قريته على الطريقة '
                'اليمنية القديمة في مدرسة القرية التي كانت تسمى: «المعلامة».\n\n'
                'ثم توجّه إلى مدينة «تعز»، وبدأ يطلب العلم في أحد معاهدها '
                'لمدة يسيرة، وكان ذلك في بداية شبابه.\n\n'
                'ثم رأى أن المعاهد لا تروي غليلًا ولا تشفي عليلًا، فتوجّه '
                'إلى «دار الحديث بدماج»، بتوفيق من الله تعالى؛ فبقي هناك '
                'يتلقّى العلم على يد الشيخ العلّامة المحدِّث مقبل بن هادي '
                'الوادعي — رحمه الله تعالى —.\n\n'
                'وقد كان قدومه إلى دار الحديث بدماج وهو يحفظ من القرآن '
                'الكريم إلى سورة الإسراء، ثم أكمل حفظ القرآن الكريم في '
                'شهرين تقريبًا.\n\n'
                'ثم تابع سيره في تلقّي العلم الشرعي، وخرج بحصيلة علمية '
                'قوية، لما يخرجه غيره بمثلها في المدة التي قضاها هناك، '
                'رغم المشاغل التي كانت تأخذ من وقته الكثير، لكنه كان سريع '
                'الحفظ، قوي الفهم، متوقّد الذهن، حريصًا على وقته، فحفظ خلال '
                'تلك المدة إلى جانب القرآن الكريم: «بلوغ المرام»، و«عمدة '
                'الأحكام»، و«الصحيح المسند من أسباب النزول»، و«ألفية ابن '
                'مالك»، و«ألفية العراقي»، وكثيرًا من صحيحي البخاري ومسلم، '
                'وأخذ عدة كتب في الفقه والحديث والعقيدة واللغة وغيرها من '
                'العلوم الشرعية.',
          ),
          _BioSection(
            icon: Icons.school_rounded,
            title: 'شيوخه',
            content:
                'تتلمذ شيخنا — حفظه الله — على يد فضيلة الشيخ العلّامة '
                'محدِّث الديار اليمنية مقبل بن هادي الوادعي — رحمه الله '
                'تعالى —.',
          ),
          _BioSection(
            icon: Icons.mosque_rounded,
            title: 'انتقاله إلى دار الحديث بمعبر',
            content:
                'بعد أن رزقه الله العلم النافع، انتقل إلى دار الحديث '
                'بمدينة «مَعْبَر» التي يقيم فيها إلى اليوم؛ للعلم والتعليم '
                'والدعوة إلى الله، على منهج أهل السنة والجماعة.\n\n'
                'فبدأ بالتعليم ولم يكن معه آنذاك سوى سبعة من الطلاب؛ فبدأ '
                'بتعليمهم القرآن الكريم، وما تيسّر من العلوم الشرعية '
                'النافعة.\n\n'
                'وبعد مدة قصيرة انتشرت دعوته في ربوع اليمن، وطارت كل مطار، '
                'وعرفها القاصي والداني، فتوافد إليه طالب العلم من كل حدب '
                'وصوب، من داخل اليمن ومن خارجها، حتى إنه لا يكاد يوجد منطقة '
                'من مناطق اليمن إلا وفيها من طالب العلم في دار الحديث '
                'بمعبر، وأصبح منهم العلماء والمؤلفون والباحثون وحفظة القرآن '
                'والدعاة إلى الله، ومنهم مجموعة لا يأتي عليها الحصر من يقوم '
                'بأمر الدعوة إلى الله في شتى بلدان العالم.',
          ),
          _BioSection(
            icon: Icons.groups_rounded,
            title: 'تلاميذه',
            content:
                'طلّابه بالآلاف، من مختلف المناطق اليمنية، ومن مختلف '
                'البلدان العربية والإسلامية وغيرها من دول العالم، لا '
                'نستطيع حصرهم؛ فهذا يبقى سنة ثم يذهب، وهذا يبقى أقل وهذا '
                'أكثر ثم يذهب فيفيد ويستفيد، وقد استفاد عدد كبير والحمد لله.',
          ),
          _DailyLifeSection(),
          _EffortsSection(),
          _BooksSection(),
          _BioSection(
            icon: Icons.auto_stories_rounded,
            title: 'كتبه قيد الإعداد',
            content:
                'ومن أنفس كتبه وأعظمها: «إجماعات المفسرين وما عليه '
                'جمهورهم» — وهو أعظم كتب شيخنا وأنفسها؛ لمادته العلمية '
                'العظيمة المتعلقة بالقرآن الكريم، وقد بذل فيه جهدًا كبيرًا، '
                'ووقتًا طويلًا، وسيكون في أكثر من ثلاثين مجلدًا بإذن الله، '
                'وقد تم أكثر العمل فيه، ولا زال العمل مستمرًّا في إتمامه.\n\n'
                'وهناك بعض الكتب العلمية النافعة التي هي قيد العمل '
                'والإعداد، منها:\n\n'
                '• «شرح صحيح الإمام مسلم» — شرح نفيس نرجو أن يكون على '
                'غرار كتب المتقدمين من حيث الفائدة والغزارة العلمية.\n'
                '• «شرح الأدب المفرد» — على وشك التجهيز للطبع بحمد الله.\n'
                '• «شرح كتاب صحيح السيرة» — يسّر الله إتمامه ونشره.',
          ),
          _BioSection(
            icon: Icons.format_quote_rounded,
            title: 'خاتمة',
            content:
                'خُتِمت هذه النبذة بقلم أبي حذيفة عبد الرحمن بن حسن الشيخ، '
                'بالتعاون مع مدير الموقع الرسمي لشيخنا الإمام، في الواحد '
                'من شهر ربيع الآخر لعام ١٤٤٥هـ.\n\n'
                'نسأل الله أن يحفظ الشيخ، وأن ينفع به، وأن يجعل عمله في '
                'ميزان حسناته، والحمد لله الذي بنعمته تتم الصالحات.',
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  البطاقة العلوية
// ═══════════════════════════════════════════════════════════

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.nightWarm,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppColors.mishkatGold.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // ✨ الشعار
          const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.mishkatGold,
            size: 26,
          ),
          const SizedBox(height: 18),

          // "سماحة شيخنا الإمام"
          const Text(
            'سماحة شيخنا الإمام',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.mishkatGold,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 10),

          // "محمد بن عبد الله الإمام"
          const Text(
            'محمد بن عبد الله الإمام',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.mishkatGold,
              height: 1.5,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),

          // "أبو نصر"
          const Text(
            'أبو نصر',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.mishkatGold,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  قسم نصي عام (ExpansionTile)
// ═══════════════════════════════════════════════════════════

class _BioSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? content;
  final Widget? child;
  final bool initiallyExpanded;

  const _BioSection({
    required this.icon,
    required this.title,
    this.content,
    this.child,
    this.initiallyExpanded = false,
  }) : assert(content != null || child != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.nightWarm,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.mishkatGold.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: AppColors.mishkatGold.withValues(alpha: 0.05),
          highlightColor: AppColors.mishkatGold.withValues(alpha: 0.03),
        ),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          iconColor: AppColors.mishkatGold,
          collapsedIconColor: AppColors.mishkatGold.withValues(alpha: 0.7),
          leading: _SectionIcon(icon: icon),
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: AppColors.moonCream,
            ),
          ),
          children: [
            if (child != null)
              child!
            else
              SizedBox(
                width: double.infinity,
                child: Text(
                  content!,
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 13,
                    color: AppColors.moonCream.withValues(alpha: 0.85),
                    height: 1.9,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SectionIcon extends StatelessWidget {
  final IconData icon;
  const _SectionIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.mishkatGold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: AppColors.mishkatGold, size: 20),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  حياته اليومية — Timeline أنيق
// ═══════════════════════════════════════════════════════════

class _DailyLifeSection extends StatelessWidget {
  const _DailyLifeSection();

  static const List<_TimelineItem> _items = [
    _TimelineItem(
      icon: Icons.wb_twilight_rounded,
      label: 'بعد الفجر',
      text:
          'يصعد إلى مكتبه بجانب المكتبة، فيؤدّي أذكار الصلاة ثم أذكار '
          'الصباح، ثم يتفرّغ للبحث والمطالعة حتى الساعة السابعة والنصف.',
    ),
    _TimelineItem(
      icon: Icons.free_breakfast_rounded,
      label: 'الفطور / الضحى',
      text:
          'يذهب إلى البيت فيتناول الفطور إن لم يكن صائمًا، ثم يعود إلى '
          'مكتبه فيصلّي الضحى، وإن كان صائمًا بقي في مكتبه مطالعًا '
          'وباحثًا حتى قرب الظهر.',
    ),
    _TimelineItem(
      icon: Icons.menu_book_rounded,
      label: 'قبيل الظهر',
      text:
          'يتخلل ذلك مقابلة بعض الطلاب أو الزوار، ثم بعد الأذان يحضّر '
          'الدرس ويصلّي الظهر.',
    ),
    _TimelineItem(
      icon: Icons.auto_stories_rounded,
      label: 'بعد الظهر',
      text:
          'يُقيم درس «تفسير الإمام السعدي»، ثم يصعد إلى مكتبه ويواصل '
          'البحث، ثم يقابل من كانت له حاجة من الطلاب وغيرهم.',
    ),
    _TimelineItem(
      icon: Icons.lunch_dining_rounded,
      label: 'الغداء',
      text:
          'يذهب إلى البيت لتناول طعام الغداء، ثم يرجع إلى مكتبه فيواصل '
          'البحث والمطالعة.',
    ),
    _TimelineItem(
      icon: Icons.hotel_rounded,
      label: 'قبيل العصر',
      text:
          'يغفو إغفاءة سريعة، ثم يقوم ويصلّي العصر، ثم يعود إلى مكتبه '
          'فيواصل البحث والمطالعة إلى قبل المغرب، ثم يحضّر درس المغرب.',
    ),
    _TimelineItem(
      icon: Icons.brightness_3_rounded,
      label: 'بعد المغرب',
      text:
          'يلقي دروسه: يوم السبت والإثنين «شرح صحيح مسلم»، ويوم الثلاثاء '
          'كتابه «حسن الأدب يطفئ غضب الرب»، ويوم الأربعاء «الداء والدواء» '
          'لابن القيم — وشرحه ماتع نفيس، يهتم بنقل الآثار وذكر إجماعات '
          'العلماء وقول جمهورهم في المسائل.',
    ),
    _TimelineItem(
      icon: Icons.nights_stay_rounded,
      label: 'بعد العشاء',
      text:
          'يصلّي العشاء ثم يصعد إلى مكتبه فيواصل البحث، ثم يفتح المجال '
          'لمن كان له سؤال أو استفسار أو إصلاح حتى ينتهي الناس، ثم يعود '
          'للبحث والمطالعة والكتابة إلى الساعة العاشرة، ثم يذهب إلى البيت.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.nightWarm,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.mishkatGold.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: AppColors.mishkatGold.withValues(alpha: 0.05),
          highlightColor: AppColors.mishkatGold.withValues(alpha: 0.03),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          iconColor: AppColors.mishkatGold,
          collapsedIconColor: AppColors.mishkatGold.withValues(alpha: 0.7),
          leading: const _SectionIcon(icon: Icons.schedule_rounded),
          title: const Text(
            'حياته اليومية',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: AppColors.moonCream,
            ),
          ),
          children: [
            for (int i = 0; i < _items.length; i++)
              _TimelineRow(
                item: _items[i],
                isFirst: i == 0,
                isLast: i == _items.length - 1,
              ),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem {
  final IconData icon;
  final String label;
  final String text;
  const _TimelineItem({
    required this.icon,
    required this.label,
    required this.text,
  });
}

class _TimelineRow extends StatelessWidget {
  final _TimelineItem item;
  final bool isFirst;
  final bool isLast;

  const _TimelineRow({
    required this.item,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الخط الزمني
          Column(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.mishkatGold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.mishkatGold.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  item.icon,
                  color: AppColors.mishkatGold,
                  size: 16,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.mishkatGold.withValues(alpha: 0.5),
                          AppColors.mishkatGold.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // النص
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 18, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: const TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mishkatGold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.text,
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 12.5,
                      color: AppColors.moonCream.withValues(alpha: 0.85),
                      height: 1.85,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  جهوده العلمية والدعوية — نقاط مرقّمة
// ═══════════════════════════════════════════════════════════

class _EffortsSection extends StatelessWidget {
  const _EffortsSection();

  static const List<String> _items = [
    'إلقاء الدروس على الطالب يوميًّا، لا ينقطع عنها إلا لعذر ضروري، وهذه الدروس لعامة الطالب، كما أن له دروسًا خاصة ببعض كبار الطالب في الدار. وجميع الدروس العامة تُنشر في الموقع الرسمي وعبر مواقع التواصل الاجتماعي.',
    'القيام بأمور الطالب، والاجتماع بالمسؤولين عليهم من أصحاب الأسر ومن طالب الدار، وتوجيههم وإرشادهم.',
    'الإجابة عن أسئلة الناس، فهو يقوم بالفتوى صوتيًّا في كل ليلة خميس، ويبقى في مجلسه فيدخل عليه كثير من الناس؛ فهذا يستفتيه في مسألة فقهية، وهذا يستشيره في أمر يخصه، وهذا يطلب منه نصيحة في أمر ما، فيستقبل تلك الجموع كلها بصدر رحب ونفس طيبة.',
    'فصل النزاع بين الناس وإصلاح ذات البين، والقيام بعقد الزواج سواء كانوا من الطالب أم من غيرهم من أهل السنة، أو من المحبين من عامة الناس، وبحمد الله فغالبهم يرتضون بحكم الشيخ بينهم، وما يخرجون من عنده إلا وقد زال ما يجدونه في صدورهم على بعضهم بعضًا، وتارة يحيل فصل النزاع إلى من يثق به من طلابه أو إخوانه.',
    'مقابلة المرضى كل سبت وثلاثاء، وهم المصابون بالمس والسحر والعين؛ من أجل إرشادهم ونصحهم وتوجيههم، وخاصة من له تعلّق بغير الله، فيغرس في قلوبهم التوحيد؛ لأنّه أساس العافية.',
    'خروج دعوي كل يوم جمعة في منطقة من المناطق اليمنية، يحضرها المئات أو الآلاف من الناس، إلا أنه انقطع عن هذا الخروج؛ نظرًا للظروف الحالية التي تمر بها بلادنا اليمنية، دفع الله عنها وعن سائر بلاد المسلمين كل سوء ومكروه.',
    'استقبال الزوار والضيوف القادمين عليه، سواء كانوا من الداخل أم من الخارج، ويفرّغ لهم وقتًا للجلوس معهم والإجابة عن أسئلتهم.',
  ];

  @override
  Widget build(BuildContext context) {
    return _BioSection(
      icon: Icons.volunteer_activism_rounded,
      title: 'جهوده العلمية والدعوية',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: AppColors.mishkatGold.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.mishkatGold.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              'لشيخنا — حفظه الله — جهود عظيمة لا يستطيع أن يقوم بمثلها '
              'إلا من حمل ما حمل من سعة الصدر، وبذل الدعوة، والتفاني في '
              'خدمة الدين، والصبر على ذلك، وهذا توفيق من الله أولًا '
              'وآخر، فأعماله جليلة وكثيرة، ومنها:',
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 12.5,
                color: AppColors.mishkatGold,
                height: 1.8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...List.generate(_items.length, (i) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: i == _items.length - 1 ? 0 : 12,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.mishkatGold.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.mishkatGold.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mishkatGold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        _items[i],
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 12.5,
                          color: AppColors.moonCream.withValues(alpha: 0.85),
                          height: 1.9,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  قسم المؤلفات الكامل
// ═══════════════════════════════════════════════════════════

class _BooksSection extends StatelessWidget {
  const _BooksSection();

  static const List<String> _volumes = [
    'الإبانة عن كيفية التعامل في الخلاف بين أهل السنة والجماعة',
    'أحكام التعامل مع الجن وآداب الرقى الشرعية',
    'الإيضاح والتبيين لما صح وما لم يصح من أحاديث الجن والشياطين',
    'بداية الانحراف ونهايته',
    'تأثير الأموال في نفوذ التنصير بين المسلمين',
    'تحذير البشر من أصول الشر',
    'العدل في الأموال قوام العالمين',
    'تمام المنة في فقه قتال الفتنة',
    'المؤامرة الغربية على اللغة العربية',
    'المؤامرة الكبرى على المرأة المسلمة',
    'نقض النظريات الكونية',
    'المجموع الثمين في أحكام الرقى والجن والشياطين',
    'مجموعة رسائل علمية وعقدية',
    'الذم والعتاب على من بنى المشاهد والقباب',
    'خطب الشيخ محمد بن عبد الله الإمام — المجموعة الأولى',
    'خطب الشيخ محمد بن عبد الله الإمام — المجموعة الثانية',
    'خطب الشيخ محمد بن عبد الله الإمام — المجموعة الثالثة',
    'شرح العقيدة الواسطية',
    'الروح والإسعاد في شرح كتاب تطهير الاعتقاد',
    'إعلام النبلاء بأحكام ميراث النساء',
    'الإيضاحات الموثقة في بيان بوائق دعوة المساواة المطلقة',
    'تحذير المسلمين من الغلو في قبور الصالحين',
    'تنوير الظلمات بكشف مفاسد وشبهات الانتخابات',
    'السيف اليماني على من أباح الأغاني',
    'الكشف المبين عن أصناف المبدلين',
    'المؤمن الضعيف',
    'بهجة الناظرين في صبر المرسلين والنبيين والصديقين',
    'روضة الأحباب في معرفة حق الآل والأصحاب',
  ];

  static const List<String> _letters = [
    'إخبار الوفود بحكم زيارة قبر النبي هود',
    'الاختلاط أصل الشر في دمار الأمم والأسر',
    'الأخطاء المتعددة في حج المرأة المتربجة',
    'إرشاد الأخيار إلى حكم نكاح الشغار',
    'إرشاد الناظر إلى معرفة علامات الساحر',
    'إعانة الأماجد ببيان حال عمرو خالد',
    'أعداءك يا مسلم أربعة',
    'إعلام الحائر في حكم حل السحر على يد الساحر',
    'إنقاذ المسلمين من وسوسة الجن والشياطين',
    'البرهان على حكم التناكح بين الإنس والجان',
    'الاختصار لما في طريق الحجوري من أضرار',
    'البيان لإيضاح ما عليه جامعة الإيمان',
    'تبصير الحيارى بموقف القرضاوي من اليهود والنصارى',
    'تحذير أهل الإيمان من تعاطي القات والشمة والدخان',
    'التنبيه الحسن في موقف المسلم من الفتن',
    'تنوير الأبصار بما في الرماية من منافع وأضرار',
    'تنوير العقول في الفرق بين النبي والرسول',
    'التوضيح والتحقيق لمسائل قطاع الطريق',
    'الحزب الاشتراكي في ربع قرن',
    'الحقائق الكبرى عن منظمتي اليونسكو وأدرى',
    'حكم الإجهاض في الإسلام',
    'الدفاع عن أم المؤمنين عائشة رضي الله عنها',
    'تنبيه العقلاء إلى حرمة دماء المسلمين ولحوم العلماء',
    'الذل والصغار على من قبل من المسلمين مساعدة الكفار',
    'رفع العلم',
    'الرياضة النسوية مجمع المنكرات الظاهرة والخفية',
    'السم الزعاف في عقيدة السقاف',
    'غوائل دعوة حوار الأديان',
    'كسب الحلال عمل الأبطال',
    'مسائل الإحصار في الحج والعمرة',
    'معركة الحجاب',
    'الوثائق التآمرية على الأمة العربية والإسلامية',
    'الوحدة اليمنية وضرورة الحفاظ عليها',
    'وظيفة الأبطال المسابقة إلى فضائل الأعمال',
    'أحوال المؤمنين الرضية في الحياة البرزخية',
    'إتحاف أهل السنة بإيضاح أصل ترك القتال في الفتنة',
    'الإفادة السنية عن حقيقة الجندر والدولة المدنية',
    'آل البيت صفوة الأحساب وأشرف الأنساب',
    'غاية المراد في إجابة الإمام عن أربعين سؤالًا في الصيام',
    'مختصر إعلام النبلاء بأحكام ميراث النساء',
    'الله يعاملك كما تعامل عباده',
    'الوجه الآخر لمنظمات الإغاثة',
    'متن غزوات الرسول صلى الله عليه وسلم للحفظ',
    'حسن الأدب يطفئ غضب الرب',
    'جريمة الاعتداء على المصالح العامة',
    'ذنوب الخلوات',
    'المرشد المفيد إلى تعدد الزوجات السعيد',
    'ثلاث خطب في الظلم',
    'فتوى في حكم تغيير القبلة اعتمادًا على الآلات الحديثة',
  ];

  @override
  Widget build(BuildContext context) {
    final total = _volumes.length + _letters.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.nightWarm,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.mishkatGold.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: AppColors.mishkatGold.withValues(alpha: 0.05),
          highlightColor: AppColors.mishkatGold.withValues(alpha: 0.03),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          iconColor: AppColors.mishkatGold,
          collapsedIconColor: AppColors.mishkatGold.withValues(alpha: 0.7),
          leading: const _SectionIcon(icon: Icons.library_books_rounded),
          title: Row(
            children: [
              const Expanded(
                child: Text(
                  'مؤلفاته',
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.moonCream,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.mishkatGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$total',
                  style: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mishkatGold,
                  ),
                ),
              ),
            ],
          ),
          children: [
            _SubHeader(
              label: 'مجلدات',
              count: _volumes.length,
              icon: Icons.auto_stories_rounded,
            ),
            const SizedBox(height: 8),
            ..._volumes.asMap().entries.map(
                  (e) => _BookItem(
                    index: e.key + 1,
                    title: e.value,
                    badge: 'مجلد',
                  ),
                ),
            const SizedBox(height: 18),
            _SubHeader(
              label: 'رسائل',
              count: _letters.length,
              icon: Icons.description_rounded,
            ),
            const SizedBox(height: 8),
            ..._letters.asMap().entries.map(
                  (e) => _BookItem(
                    index: e.key + 1,
                    title: e.value,
                    badge: 'رسالة',
                  ),
                ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.mishkatGold.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.mishkatGold.withValues(alpha: 0.2),
                ),
              ),
              child: const Text(
                'وله غيرها من المؤلفات والرسائل النافعة التي تجاوزت '
                'الثمانين ما بين كتاب ورسالة، منها المطوَّلة ومنها '
                'المختصرة.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 12,
                  color: AppColors.mishkatGold,
                  height: 1.7,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubHeader extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;

  const _SubHeader({
    required this.label,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.mishkatGold, size: 16),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.mishkatGold,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '($count)',
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 11,
            color: AppColors.moonCream.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.mishkatGold.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }
}

class _BookItem extends StatelessWidget {
  final int index;
  final String title;
  final String badge;

  const _BookItem({
    required this.index,
    required this.title,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = badge == 'مجلد'
        ? AppColors.mishkatGold
        : AppColors.moonCream.withValues(alpha: 0.75);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.nightDeep.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.mishkatGold.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.mishkatGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$index',
              style: const TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.mishkatGold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 12.5,
                color: AppColors.moonCream.withValues(alpha: 0.9),
                height: 1.7,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                color: badgeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}