enum categorys {
  parenting,
  education,
  games,
  nutrition,
  sports,
  illness,
  psychology,
  stories,
  hints,
  other
}

categorys returnCategory(int index) {
  switch (index) {
    case 1:
      return categorys.parenting;
    case 2:
      return categorys.education;
    case 3:
      return categorys.games;
    case 4:
      return categorys.nutrition;
    case 5:
      return categorys.sports;
    case 6:
      return categorys.illness;
    case 7:
      return categorys.psychology;
    case 8:
      return categorys.stories;
    case 9:
      return categorys.hints;
    case 10:
      return categorys.other;
    default:
      return categorys.other;
  }
}

int returnIndex(categorys category) {
  switch (category) {
    case categorys.parenting:
      return 1;
    case categorys.education:
      return 2;
    case categorys.games:
      return 3;
    case categorys.nutrition:
      return 4;
    case categorys.sports:
      return 5;
    case categorys.illness:
      return 6;
    case categorys.psychology:
      return 7;
    case categorys.stories:
      return 8;
    case categorys.hints:
      return 9;
    case categorys.other:
      return 10;
    default:
      return 10;
  }
}

String translateCategoryByText(String tagName) {
  switch (tagName) {
    case 'parenting':
      return 'воспитание';
    case 'education':
      return 'обучение';
    case 'games':
      return 'игры';
    case 'nutrition':
      return 'питание';
    case 'sports':
      return 'спорт';
    case 'illness':
      return 'здоровье';
    case 'psychology':
      return 'психология';
    case 'stories':
      return 'истории';
    case 'hints':
      return 'советы';
    case 'other':
      return 'другое';
    default:
      return tagName;
  }
}

String translateCategoryByCategory(categorys category) {
  switch (category) {
    case categorys.parenting:
      return 'воспитание';
    case categorys.education:
      return 'обучение';
    case categorys.games:
      return 'игры';
    case categorys.nutrition:
      return 'питание';
    case categorys.sports:
      return 'спорт';
    case categorys.illness:
      return 'здоровье';
    case categorys.psychology:
      return 'психология';
    case categorys.stories:
      return 'истории';
    case categorys.hints:
      return 'советы';
    case categorys.other:
      return 'другое';
    default:
      return '';
  }
}

String translateCategoryByCategoryEng(categorys category) {
  switch (category) {
    case categorys.parenting:
      return 'parenting';
    case categorys.education:
      return 'education';
    case categorys.games:
      return 'games';
    case categorys.nutrition:
      return 'nutrition';
    case categorys.sports:
      return 'sports';
    case categorys.illness:
      return 'illness';
    case categorys.psychology:
      return 'psychology';
    case categorys.stories:
      return 'stories';
    case categorys.hints:
      return 'hints';
    case categorys.other:
      return 'other';
    default:
      return '';
  }
}

Future<List<String>> getCategoryStringsByIndices(List<int> indices) async {
  return indices.map((index) => translateCategoryByCategoryEng(returnCategory(index))).toList();
}
