package com.example.subscriptionguardian;

import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.SharedPreferences;
import android.widget.RemoteViews;
import es.antonborri.home_widget.HomeWidgetPlugin;

public class HomeWidgetProvider extends AppWidgetProvider {
    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        for (int appWidgetId : appWidgetIds) {
            RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.home_widget);
            SharedPreferences prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE);
            String upcomingRenewals = prefs.getString("upcoming_renewals", "No upcoming renewals");
            views.setTextViewText(R.id.widget_content, upcomingRenewals);
            appWidgetManager.updateAppWidget(appWidgetId, views);
        }
    }
}