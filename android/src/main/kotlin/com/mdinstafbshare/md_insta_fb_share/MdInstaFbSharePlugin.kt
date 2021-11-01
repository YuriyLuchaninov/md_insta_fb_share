package com.mdinstafbshare.md_insta_fb_share

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.content.res.TypedArray
import android.graphics.Bitmap
import android.net.Uri
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import androidx.core.content.FileProvider
import androidx.core.net.toUri
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import java.io.File
import java.net.URI
import androidx.core.content.ContextCompat.startActivity
import com.facebook.share.model.SharePhoto
import com.facebook.share.model.SharePhotoContent
import com.facebook.share.widget.ShareDialog
import java.lang.Exception

/** MdInstaFbSharePlugin */
class MdInstaFbSharePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var activity: Activity
    private lateinit var channel: MethodChannel
    private val INSTAGRAM_PACKAGE_NAME: String = "com.instagram.android"
    private val FB_PACKAGE_NAME: String = "com.facebook.katana"


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "md_insta_fb_share")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "share_insta_story" -> {
                if (checkAppInstalled(INSTAGRAM_PACKAGE_NAME)) {
                    val uri = try {
                        getPictureUri(call)
                    } catch (e : Exception) {
                        result.success(2)
                        return
                    }

                    val intent = Intent("com.instagram.share.ADD_TO_STORY")
                    intent.setDataAndType(uri, "image/*")
                    intent.flags = Intent.FLAG_GRANT_READ_URI_PERMISSION


                    activity.startActivityForResult(intent, 0)
                    result.success(0)
                } else {
                    openMissingAppInPlayStore(INSTAGRAM_PACKAGE_NAME)
                    result.success(1)
                }
            }
            "share_insta_feed" -> {
                if (checkAppInstalled(INSTAGRAM_PACKAGE_NAME)) {
                    val uri = try {
                        getPictureUri(call)
                    } catch (e : Exception) {
                        result.success(2)
                        return
                    }

                    val intent = Intent("com.instagram.share.ADD_TO_FEED")
                    intent.type = "image/*"
                    intent.putExtra(Intent.EXTRA_STREAM, uri)

                    activity.grantUriPermission(
                            "com.instagram.android", uri, Intent.FLAG_GRANT_READ_URI_PERMISSION);

                    activity.startActivityForResult(intent, 0)
                    result.success(0)
                } else {
                    openMissingAppInPlayStore(INSTAGRAM_PACKAGE_NAME)
                    result.success(1)
                }
            }

            "share_FB_story" -> {
                if (checkAppInstalled(FB_PACKAGE_NAME)) {
                    val uri = try {
                        getPictureUri(call)
                    } catch (e : Exception) {
                        result.success(2)
                        return
                    }

                    val intent = Intent("com.facebook.stories.ADD_TO_STORY")
                    intent.setDataAndType(uri, "image/jpeg")
                    intent.flags = Intent.FLAG_GRANT_READ_URI_PERMISSION
                    val metadata = activity.getPackageManager().getApplicationInfo(activity.getPackageName(), PackageManager.GET_META_DATA).metaData
                    intent.putExtra("com.facebook.platform.extra.APPLICATION_ID", metadata.getString("com.facebook.sdk.ApplicationId"))

                    activity.startActivityForResult(intent, 0)
                    result.success(0)
                } else {
                    openMissingAppInPlayStore(FB_PACKAGE_NAME)
                    result.success(1)
                }

            }

            "share_FB_feed" -> {
                if (checkAppInstalled(FB_PACKAGE_NAME)) {
                    val uri = try {
                        getPictureUri(call)
                    } catch (e : Exception) {
                        result.success(2)
                        return
                    }

                    val photo = SharePhoto.Builder().setImageUrl(uri).build()
                    val content = SharePhotoContent.Builder().addPhoto(photo).build()
                    ShareDialog.show(activity, content);
                    result.success(0)
                } else {
                    openMissingAppInPlayStore(FB_PACKAGE_NAME)
                    result.success(0)
                }
            }

            "check_insta" -> result.success(checkAppInstalled(INSTAGRAM_PACKAGE_NAME))

            "check_FB" -> result.success(checkAppInstalled(FB_PACKAGE_NAME))

            else -> result.notImplemented();
        }
    }

    private fun getPictureUri(call: MethodCall): Uri {
        val path = call.argument<String>("backgroundImage") ?: ""

        return FileProvider.getUriForFile(activity, activity.packageName + ".mdInstaFbShare.provider", File(path))
    }

    private fun checkAppInstalled(packageName: String): Boolean {
        return try {
            activity.packageManager.getApplicationInfo(packageName, 0)

            true
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }

    private fun openMissingAppInPlayStore(packageName: String) {
        val intent = Intent(Intent.ACTION_VIEW)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        intent.data = Uri.parse("market://details?id=$packageName")
        activity.startActivity(intent)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(activityPluginBinding: ActivityPluginBinding) {
        activity = activityPluginBinding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(activityPluginBinding: ActivityPluginBinding) {}

    override fun onDetachedFromActivity() {}
}
