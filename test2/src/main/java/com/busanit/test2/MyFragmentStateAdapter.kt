package com.busanit.test2

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.viewpager2.adapter.FragmentStateAdapter

class MyFragmentStateAdapter(fragmentActivity: FragmentActivity,
    val fragmentList: MutableList<Fragment>) :
    FragmentStateAdapter(fragmentActivity) {

    override fun getItemCount(): Int = 3
    override fun createFragment(position: Int): Fragment {
        return fragmentList[position]
    }


}