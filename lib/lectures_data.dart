/// ملف بيانات خطب العلامة الشيخ محمد بن عبدالله الإمام
/// لعام 1447 هـ - دار الحديث بمعبر
library;

class Lecture {
  final int id;
  final String title;
  final String fileName;
  final String? hijriDate;   // التاريخ الهجري
  final String? month;        // اسم الشهر الهجري

  Lecture({
    required this.id,
    required this.title,
    required this.fileName,
    this.hijriDate,
    this.month,
  });

  String get path => 'audio_compressed/$fileName';
}

final List<Lecture> lecturesList = <Lecture>[
  Lecture(id: 1,  title: 'الأفلام الإجرامية وضررها على الأجيال الإسلامية', fileName: '1.opus',  hijriDate: '٢ محرم ١٤٤٧', month: 'محرم'),
  Lecture(id: 2,  title: 'السبب الأهم في تفضيل هذه الأمة على سائر الأمم', fileName: '2.opus',  hijriDate: '٩ محرم ١٤٤٧', month: 'محرم'),
  Lecture(id: 3,  title: 'نجاة هذه الأمة بالاعتصام بالكتاب والسنة', fileName: '3.opus',  hijriDate: '١٦ محرم ١٤٤٧', month: 'محرم'),
  Lecture(id: 4,  title: 'من اغتر بإمهاله كان سبباً لزواله', fileName: '4.opus',  hijriDate: '٢٣ محرم ١٤٤٧', month: 'محرم'),
  Lecture(id: 5,  title: 'الكواكب النيرات في كشف بعض الشبهات', fileName: '5.opus',  hijriDate: '٣٠ محرم ١٤٤٧', month: 'محرم'),
  Lecture(id: 6,  title: 'أهمية معرفة الله', fileName: '6.opus',  hijriDate: '٧ صفر ١٤٤٧', month: 'صفر'),
  Lecture(id: 7,  title: 'أهمية تحقيق العبودية', fileName: '7.opus',  hijriDate: '١٤ صفر ١٤٤٧', month: 'صفر'),
  Lecture(id: 8,  title: 'تعظيم الصلوات على غيرها من العبادات', fileName: '8.opus',  hijriDate: '٢١ صفر ١٤٤٧', month: 'صفر'),
  Lecture(id: 9,  title: 'العذب النمير في شرح اسم الله القادر المقتدر القدير', fileName: '9.opus',  hijriDate: '٢٨ صفر ١٤٤٧', month: 'صفر'),
  Lecture(id: 10, title: 'التأييدات الإلهية في الهجرة النبوية', fileName: '10.opus', hijriDate: '٦ ربيع الأول ١٤٤٧', month: 'ربيع الأول'),
  Lecture(id: 11, title: 'العبر والعظات في الزلازل والفيضانات', fileName: '11.opus', hijriDate: '١٣ ربيع الأول ١٤٤٧', month: 'ربيع الأول'),
  Lecture(id: 12, title: 'من لم يؤمن بالقدر لم يهنأ بعيش', fileName: '12.opus', hijriDate: '٢٠ ربيع الأول ١٤٤٧', month: 'ربيع الأول'),
  Lecture(id: 13, title: 'الحكم والأسرار في الحوادث والأقدار', fileName: '13.opus', hijriDate: '٢٧ ربيع الأول ١٤٤٧', month: 'ربيع الأول'),
  Lecture(id: 14, title: 'الدرر المنتظمة في تفسير آية ﴿وجعل بينكم مودة ورحمة﴾', fileName: '14.opus', hijriDate: '٤ ربيع الآخر ١٤٤٧', month: 'ربيع الآخر'),
  Lecture(id: 15, title: 'الإعلام بنعمة الفطرة على الإسلام', fileName: '15.opus', hijriDate: '١١ ربيع الآخر ١٤٤٧', month: 'ربيع الآخر'),
  Lecture(id: 16, title: 'نماذج من جهود علماء الملة في دفع الشبهات المضلة', fileName: '16.opus', hijriDate: '١٨ ربيع الآخر ١٤٤٧', month: 'ربيع الآخر'),
  Lecture(id: 17, title: 'من عقوبات العصاة في الآخرة', fileName: '17.opus', hijriDate: '٢٥ ربيع الآخر ١٤٤٧', month: 'ربيع الآخر'),
  Lecture(id: 18, title: 'الغزو الفكري وخطره على المسلمين', fileName: '18.opus', hijriDate: '٢ جمادى الأولى ١٤٤٧', month: 'جمادى الأولى'),
  Lecture(id: 19, title: 'تبشير الأنام بأن العاقبة للإسلام', fileName: '19.opus', hijriDate: '٩ جمادى الأولى ١٤٤٧', month: 'جمادى الأولى'),
  Lecture(id: 20, title: 'لفت الانتباه إلى عمارة القلوب بحب الصلاة', fileName: '20.opus', hijriDate: '٢٣ جمادى الأولى ١٤٤٧', month: 'جمادى الأولى'),
  Lecture(id: 21, title: 'الخطاب في بيان داء ودواء الشباب', fileName: '21.opus', hijriDate: '٣٠ جمادى الأولى ١٤٤٧', month: 'جمادى الأولى'),
  Lecture(id: 22, title: 'الافتقار إلى الله في دفع الشرور', fileName: '22.opus', hijriDate: '٧ جمادى الآخرة ١٤٤٧', month: 'جمادى الآخرة'),
  Lecture(id: 23, title: 'تدبير الرب الواسع لما في الدنيا من منافع', fileName: '23.opus', hijriDate: '١٤ جمادى الآخرة ١٤٤٧', month: 'جمادى الآخرة'),
  Lecture(id: 24, title: 'سبيل النجاة في تحقيق عبودية الله', fileName: '24.opus', hijriDate: '٢١ جمادى الآخرة ١٤٤٧', month: 'جمادى الآخرة'),
  Lecture(id: 25, title: 'دعوة أهل الإيمان إلى الغيرة على القرآن', fileName: '25.opus', hijriDate: '٢٨ جمادى الآخرة ١٤٤٧', month: 'جمادى الآخرة'),
  Lecture(id: 26, title: '﴿ونبلوكم بالشر والخير فتنة﴾', fileName: '26.opus', hijriDate: '٦ رجب ١٤٤٧', month: 'رجب'),
  Lecture(id: 27, title: 'الكشف والتبيين لبعض أسباب القتال بين المسلمين', fileName: '27.opus', hijriDate: '١٣ رجب ١٤٤٧', month: 'رجب'),
  Lecture(id: 28, title: 'أهمية نعمة الأمن والاستقرار', fileName: '28.opus', hijriDate: '٢٠ رجب ١٤٤٧', month: 'رجب'),
  Lecture(id: 29, title: 'هذه دعوتنا', fileName: '29.opus', hijriDate: '٢٧ رجب ١٤٤٧', month: 'رجب'),
  Lecture(id: 30, title: 'شعبان بين الاتباع والابتداع', fileName: '30.opus', hijriDate: '٤ شعبان ١٤٤٧', month: 'شعبان'),
  Lecture(id: 31, title: 'تشنيف الآذان بصفات أهل الجنة في القرآن', fileName: '31.opus', hijriDate: '١١ شعبان ١٤٤٧', month: 'شعبان'),
  Lecture(id: 32, title: 'التخويف والإنذار ببعض صفات أهل النار', fileName: '32.opus', hijriDate: '١٨ شعبان ١٤٤٧', month: 'شعبان'),
  Lecture(id: 33, title: 'رمضان أُنس الأرواح وموسم الأرباح', fileName: '33.opus', hijriDate: '٢٥ شعبان ١٤٤٧', month: 'شعبان'),
  Lecture(id: 34, title: 'درر البيان في عظمة هداية القرآن', fileName: '34.opus', hijriDate: '٣ رمضان ١٤٤٧', month: 'رمضان'),
  Lecture(id: 35, title: 'البيان لحقوق الله في الأموال', fileName: '35.opus', hijriDate: '١٠ رمضان ١٤٤٧', month: 'رمضان'),
  Lecture(id: 36, title: 'بركات ومنافع التوبة إلى الله', fileName: '36.opus', hijriDate: '١٧ رمضان ١٤٤٧', month: 'رمضان'),
  Lecture(id: 37, title: 'السعادة الأبدية في لزوم عتبة العبودية', fileName: '37.opus', hijriDate: '١ شوال ١٤٤٧', month: 'شوال'),
  Lecture(id: 38, title: 'البرهان في عداوة الشيطان للإنسان', fileName: '38.opus', hijriDate: '٢٢ شوال ١٤٤٧', month: 'شوال'),
  Lecture(id: 39, title: 'من حكم الابتلاء في السراء والضراء', fileName: '39.opus', hijriDate: '٢٩ شوال ١٤٤٧', month: 'شوال'),
  Lecture(id: 40, title: 'درر البيان في التسلح والتحصن من الشيطان', fileName: '40.opus', hijriDate: '٧ ذو القعدة ١٤٤٧', month: 'ذو القعدة'),
  Lecture(id: 41, title: 'تحذير الإنس من شياطين الإنس', fileName: '41.opus', hijriDate: '١٤ ذو القعدة ١٤٤٧', month: 'ذو القعدة'),
  Lecture(id: 42, title: 'الشهوات بريد شياطين الإنس والجن إلى المنكرات', fileName: '42.opus', hijriDate: '٢١ ذو القعدة ١٤٤٧', month: 'ذو القعدة'),
  Lecture(id: 43, title: 'أثر شبهات الكافرين في إفساد المسلمين', fileName: '43.opus', hijriDate: '٢٨ ذو القعدة ١٤٤٧', month: 'ذو القعدة'),
  Lecture(id: 44, title: 'طيب النشر في اغتنام العشر', fileName: '44.opus', hijriDate: '٦ ذو الحجة ١٤٤٧', month: 'ذو الحجة'),
  Lecture(id: 45, title: 'التأكيد على مواساة الفقراء يوم العيد', fileName: '45.opus', hijriDate: '١٠ ذو الحجة ١٤٤٧', month: 'ذو الحجة'),
  Lecture(id: 46, title: 'خطر الإصرار على الذنوب والأوزار', fileName: '46.opus', hijriDate: '٢٦ ذو الحجة ١٤٤٧', month: 'ذو الحجة'),
];