//
//  BridgingHeader.h
//  SQLiteWrapper
//
//  Created by Cindy Oakes on 5/28/16.
//  Copyright © 2016 Cindy Oakes. All rights reserved.
//

// 1. Create this file in your Xcode project
// 2. Go to "Build Settings" and find "Objective-C Bridging Header." Use the search bar to find it quickly.
// 3. Double-click and type "BridgingHeader.h"
//    If you get "Could not import Objective-C Header," try "my-project-name/BridgingHeader.h"
// 4. Go to "Build Phases," "Link Binary With Libraries," and add libsqlite3.0.dylib or libsqlite3.tbd

#include <sqlite3.h>
