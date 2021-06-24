//
//  PhotosViewController.m
//  Tumblr
//
//  Created by Ava Crnkovic-Rubsamen on 6/24/21.
//

#import "PhotosViewController.h"
#import "PhotoCell.h"
#import "UIImageView+AFNetworking.h"

@interface PhotosViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *phoneView;


@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    NSURL *url = [NSURL URLWithString:@"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@", dataDictionary);

                // TODO: Get the posts and store in posts property
                // Get the dictionary from the response key
                NSDictionary *responseDictionary = dataDictionary[@"response"];
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary[@"posts"];
                
                // TODO: Reload the table view
                [self.tableView reloadData];
            }
        }];
    [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    NSDictionary *post = self.posts[indexPath.row];
    
    NSArray *photos = post[@"photos"];
    
    if (photos) {
        // 1. Get the first photo in the photos array
        NSDictionary *photo = photos[0];

        // 2. Get the original size dictionary from the photo
        NSDictionary *originalSize =  photo[@"original_size"];

        // 3. Get the url string from the original size dictionary
        NSString *urlString = originalSize[@"url"];
        
        // NSLog(@"%@", originalSize[@"height"]);
        // NSLog(@"%@", originalSize[@"width"]);
        
        
        // original height/width = new height/width
        // new width * original height/width
        
        
        int originalHeight = [originalSize[@"height"] intValue];
        int originalWidth = [originalSize[@"width"] intValue];
        
        NSLog(@"%f", self.phoneView.bounds.size.width);
        
        int rowHeight = self.phoneView.bounds.size.width * originalHeight / originalWidth;
        
        // NSLog(@"%i", rowHeight);
        
        
        
        // NSInteger imageHeight = originalSize[@"height"];
        self.tableView.rowHeight = rowHeight;
        
        

        // 4. Create a URL using the urlString
        NSURL *url = [NSURL URLWithString:urlString];
        
        [cell.photoView setImageWithURL:url];
        
        // [self.tableView reloadData];
        // self.tableView.rowHeight = 300;
    }
    else {
        // we will figure this out later
    }
    

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

@end
