package com.example.four_2_ten;
import android.os.Bundle;
import android.util.Log;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.AuthResult;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.firebase.auth.FirebaseUser;
import com.google.android.gms.tasks.Task;

public class MainActivity extends FlutterActivity {
    private String CHANNEL = "com.example.four_2_ten/android_channel";
    private FirebaseAuth auth;
    private String id;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        auth = FirebaseAuth.getInstance();
    }

    @Override
    public void onStart() {
        super.onStart();
        this.auth.signInAnonymously()
                .addOnCompleteListener(this, new OnCompleteListener<AuthResult>() {
                    @Override
                    public void onComplete(@NonNull Task<AuthResult> task) {
                        if (task.isSuccessful()) {
                            System.out.println("signInAnonymously:success");
                            FirebaseUser user = auth.getCurrentUser();
                            if (user != null) {
                                id = user.getUid();
                            }
                        } else {
                            System.out.println("signInAnonymously:failure");
                        }
                    }
                });
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("getId")) {
                                result.success(getId());
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    private String getId() {
        return this.id;
    }
}

