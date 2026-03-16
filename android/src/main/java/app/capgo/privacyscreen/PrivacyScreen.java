package app.capgo.privacyscreen;

import android.app.Activity;
import android.os.Looper;
import android.view.Window;
import android.view.WindowManager;

public class PrivacyScreen {

    private final Activity activity;
    private boolean enabled;

    public PrivacyScreen(final Activity activity) {
        this.activity = activity;
    }

    public void enable() {
        enabled = true;
        runOnMainThread(() -> {
            final Window window = activity.getWindow();
            if (window != null) {
                window.addFlags(WindowManager.LayoutParams.FLAG_SECURE);
            }
        });
    }

    public void disable() {
        enabled = false;
        runOnMainThread(() -> {
            final Window window = activity.getWindow();
            if (window != null) {
                window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE);
            }
        });
    }

    public boolean isEnabled() {
        return enabled;
    }

    private void runOnMainThread(final Runnable action) {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            action.run();
        } else {
            activity.runOnUiThread(action);
        }
    }
}
