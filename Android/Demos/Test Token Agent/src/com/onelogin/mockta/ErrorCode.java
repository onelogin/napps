package com.onelogin.mockta;

/**
 * Created by lineelik on 6/13/14.
 */
public class ErrorCode {
    public static final int NAPPSNetworkNotAvailable = 1000;
    public static final int NAPPSIDPDidNotRespond = 1100;
    public static final int NAPPSRequestingAppDoesNotHavePermission = 1201;
    public static final int NAPPSSecondaryTokenRequestRejected = 1202;
    public static final int NAPPSAppInfoListRefreshFailed = 1203;  // Couldn't retrieve the App Info List
    public static final int NAPPSTokenAgentNotInstalled = 1300;
    public static final int NAPPSNoSessionActive = 1500;
    public static final int NAPPSDeviceCouldNotBeEnrolled = 1600;
    public static final int NAPPSNone = 0;
}
