class Feedbacks {
   int rating;
   String feedback;
  

   Feedbacks(
      this.rating,
      this.feedback,
     
  );

  

  Feedbacks.fromJson(Map<String, dynamic> json){
      rating = json['rating'];
      feedback =json['feedback'];
  }
}