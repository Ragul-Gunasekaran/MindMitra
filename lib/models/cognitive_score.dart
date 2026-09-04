class CognitiveScore {
  int memory;
  int attention;
  int language;
  int math;
  int reaction;
  int problemSolving;
  
  CognitiveScore({
    this.memory = 0,
    this.attention = 0,
    this.language = 0,
    this.math = 0,
    this.reaction = 0,
    this.problemSolving = 0,
  });

  int get overall => ((memory + attention + language + math + reaction + problemSolving) / 6).round();
}
