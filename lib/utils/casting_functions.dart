addDecimalInString(String string) {
  try {
    return double.tryParse(string)?.toStringAsFixed(2) ??
        'Erro ao exibir o valor';
  } catch (error) {
    return error;
  }
}
