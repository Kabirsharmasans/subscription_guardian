package com.example.subscriptionguardian

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class HomeWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        val prefs = context.getSharedPreferences("home_widget", Context.MODE_PRIVATE)
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.home_widget_layout).apply {
                val upcomingRenewals = prefs.getString("upcoming_renewals", "No upcoming renewals")
                setTextViewText(R.id.widget_data, upcomingRenewals)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
