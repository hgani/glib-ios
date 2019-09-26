#if INCLUDE_UILIBS

import MaterialComponents.MaterialList

open class MCollectionViewCell: MDCSelfSizingStereoCell {
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
}

#endif
