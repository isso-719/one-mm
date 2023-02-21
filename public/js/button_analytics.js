function ButtonAnalytics(label) {
  gtag(
    "event", "click",
    {
        "event_name": "clicked_button",
        "event_category": "button",
        "event_label": label
    }
  );
}