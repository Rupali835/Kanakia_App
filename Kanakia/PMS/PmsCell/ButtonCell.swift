
import UIKit

class ButtonCell: UITableViewCell {
  
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblAdedBy: UILabel!
    @IBOutlet weak var lblAddname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
          self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
