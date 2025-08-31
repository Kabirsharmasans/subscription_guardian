import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import com.example.subscriptionguardian.R
import es.antonborri.home_widget.HomeWidgetProvider

class HomeWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context?, appWidgetManager: AppWidgetManager?, appWidgetIds: IntArray?) {
        if (context == null || appWidgetManager == null || appWidgetIds == null) return
        
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
